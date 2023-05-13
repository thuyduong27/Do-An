import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerBox1 extends StatefulWidget {
  final Widget? label;
  final int? flexLabel;
  final int? flexDatePiker;
  String? dateDisplay;
  String? timeDisplay;
  Function? selectedDateFunction;
  Function? selectedTimeFunction;
  bool? isTime = false;
  String? requestDayAfter;
  String? requestDayBefore;
  Function? getFullTime;
  DatePickerBox1(
      {Key? key,
      this.label,
      this.flexLabel,
      this.flexDatePiker,
      this.selectedDateFunction,
      this.selectedTimeFunction,
      this.dateDisplay,
      this.timeDisplay,
      this.requestDayAfter,
      this.requestDayBefore,
      this.getFullTime,
      this.isTime})
      : super(key: key);
  @override
  State<DatePickerBox1> createState() => DatePickerBox1State();
}

class DatePickerBox1State extends State<DatePickerBox1> {
  DateTime selectedDate = DateTime.now();
  String? dateDisplay;
  String? timeDisplay;
  bool _decideWhichDayToEnable(DateTime day) {
    if (widget.requestDayAfter == null && widget.requestDayBefore == null) {
      return true;
    } else if (widget.requestDayAfter != null && widget.requestDayBefore != null) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime requestAfter = dateFormat.parse(widget.requestDayAfter!);
      DateTime requestBefore = dateFormat.parse(widget.requestDayBefore!);
      if (day.isAfter(requestAfter) && day.isBefore(requestBefore)) {
        return true;
      }
    } else if (widget.requestDayAfter != null) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime request = dateFormat.parse(widget.requestDayAfter!);
      if (day.isAfter(request)) {
        return true;
      }
    } else if (widget.requestDayBefore != null) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime request = dateFormat.parse(widget.requestDayBefore!);
      if (day.isBefore(request)) {
        return true;
      }
    }

    return false;
  }

  _selectDate(BuildContext context) async {
    if (widget.requestDayAfter != null) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime request = dateFormat.parse(widget.requestDayAfter!);
      selectedDate = request.add(Duration(days: 1));
      dateDisplay = DateFormat("dd-MM-yyyy").format(selectedDate.toLocal());
      widget.selectedDateFunction!(dateDisplay);
    }
    if (widget.requestDayBefore != null) {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      DateTime request = dateFormat.parse(widget.requestDayBefore!);
      selectedDate = request.subtract(Duration(days: 1));
      dateDisplay = DateFormat("dd-MM-yyyy").format(selectedDate.toLocal());
      widget.selectedDateFunction!(dateDisplay);
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1960),
        lastDate: DateTime(2025),
        selectableDayPredicate: _decideWhichDayToEnable);
    if (picked != null)
      setState(() {
        selectedDate = picked;
        dateDisplay = DateFormat("dd-MM-yyyy").format(selectedDate.toLocal());
        widget.selectedDateFunction!(dateDisplay);
      });
  }

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, childWidget) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                  // Using 24-Hour format
                  alwaysUse24HourFormat: true),
              // If you want 12-Hour format, just change alwaysUse24HourFormat to false or remove all the builder argument
              child: childWidget!);
        });
    if (newTime != null) {
      setState(() {
        _time = newTime;
        timeDisplay = _time.format(context).toString();
        widget.selectedTimeFunction!(timeDisplay);
        convertTimeStamp(dateDisplay!, timeDisplay!);
        widget.getFullTime!(convertTimeStamp(dateDisplay!, timeDisplay!));
      });
    }
  }

  @override
  void initState() {
    if (widget.dateDisplay != null) {
      dateDisplay = widget.dateDisplay;
      timeDisplay = widget.timeDisplay;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.label != null)
          Expanded(
            flex: widget.flexLabel ?? 2,
            child: widget.label!,
          ),
        Expanded(
          flex: widget.flexDatePiker ?? 5,
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.15,
                  height: 40,
                  padding: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    border: Border.all(width: 0.5, style: BorderStyle.solid),
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dateDisplay ?? 'Chọn ngày', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      SizedBox(height: 20.0),
                      dateDisplay == null
                          ? IconButton(onPressed: () => _selectDate(context), icon: Icon(Icons.date_range), color: Colors.blue[400])
                          : IconButton(
                              onPressed: () {
                                dateDisplay = null;
                                widget.selectedDateFunction!(dateDisplay);

                                setState(() {});
                              },
                              icon: Icon(Icons.close)),
                    ],
                  ),
                ),
              ),
              widget.isTime != false
                  ? Expanded(
                      flex: 2,
                      child: Container(
                        // width: MediaQuery.of(context).size.width * 0.15,
                        height: 40,
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.5, style: BorderStyle.solid),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(timeDisplay ?? 'Chọn giờ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20.0),
                            timeDisplay == null
                                ? IconButton(onPressed: () => _selectTime(), icon: Icon(Icons.schedule), color: Colors.blue[400])
                                : IconButton(
                                    onPressed: () {
                                      timeDisplay = null;
                                      widget.selectedTimeFunction!(timeDisplay);
                                      setState(() {});
                                    },
                                    icon: Icon(Icons.close)),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}
String displayDateTimeStamp(String date) {
  DateTime time = DateTime.parse(date);
  return DateFormat("yyyy-MM-dd").format(time.add(Duration(hours: 7))).toString();
}

String displayTimeStamp(date) {
  DateTime time = DateTime.parse(date);
  return DateFormat("HH:mm").format(time.toLocal()).toString();
}

String convertTimeStamp(String date, String? time) {
  String dateTimeString = '${dateReverse(date)}T$time';
  final dateTime = DateTime.parse(dateTimeString);
  // DateTime dateTime = DateTime.parse("$date $time");
  return DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateTime).toString();
}
String dateReverse(date) {
  String dateReversed = '';
  var string = date.split('-');
  for (int i = string.length - 1; i >= 0; i--) {
    dateReversed += string[i];
    if (i > 0) dateReversed += '-';
  }
  return dateReversed;
}