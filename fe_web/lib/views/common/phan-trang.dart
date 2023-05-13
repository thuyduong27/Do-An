import 'package:flutter/material.dart';

class DynamicTablePagging extends StatelessWidget {
  final int rowCount; //demsodong
  final int currentPage; //trang hien tai
  final int rowPerPage; // so dong tren moi trang
  final Function? pageChangeHandler;
  final Function? rowPerPageChangeHandler;
  const DynamicTablePagging(this.rowCount, this.currentPage, this.rowPerPage,
      {Key? key, this.pageChangeHandler, this.rowPerPageChangeHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rowCount > 0) {
      var firstRow = (currentPage - 1) * rowPerPage + 1;
      var lastRow = currentPage * rowPerPage;
      if (lastRow > rowCount) {
        lastRow = rowCount;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Expanded(flex: 1, child: Container()),
          const Text(
            "Số dòng trên trang:",
            style: TextStyle(fontSize: 14),
          ),
          DropdownButton<int>(
            value: rowPerPage,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 20.0,
            ),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int? newValue) {
              if (rowPerPageChangeHandler != null) {
                rowPerPageChangeHandler!(newValue);
              }
            },
            items: <int>[2, 5, 10, 25, 50, 100]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          ),
          Text("Dòng $firstRow-$lastRow của $rowCount",
              style: TextStyle(fontSize: 14)),
          IconButton(
              onPressed: (pageChangeHandler != null && firstRow != 1)
                  ? () {
                      pageChangeHandler!(currentPage - 1);
                    }
                  : null,
              icon: const Icon(
                Icons.chevron_left,
                size: 20.0,
              )),
          IconButton(
              onPressed: (pageChangeHandler != null && lastRow < rowCount)
                  ? () {
                      pageChangeHandler!(currentPage + 1);
                    }
                  : null,
              icon: const Icon(
                Icons.chevron_right,
                size: 20.0,
              )),
        ],
      );
    }
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Center(child: Text('Không có kết quả phù hợp')),
      ],
    ));
  }
}

class DynamicTablePaggingWithData extends StatelessWidget {
  final int rowCount;
  final int currentPage;
  final int rowPerPage;
  final Function? pageChangeHandler;
  final Function? rowPerPageChangeHandler;
  const DynamicTablePaggingWithData(
      this.rowCount, this.currentPage, this.rowPerPage,
      {Key? key, this.pageChangeHandler, this.rowPerPageChangeHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rowCount > 0) {
      var firstRow = (currentPage - 1) * rowPerPage + 1;
      var lastRow = currentPage * rowPerPage;
      if (lastRow > rowCount) {
        lastRow = rowCount;
      }
      return Row(
        children: [
          Expanded(flex: 1, child: Container()),
          const Text("Số dòng trên trang: "),
          DropdownButton<int>(
            value: rowPerPage,
            icon: const Icon(Icons.keyboard_arrow_down),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (int? newValue) {
              if (rowPerPageChangeHandler != null) {
                rowPerPageChangeHandler!(newValue);
              }
            },
            items: <int>[2, 5, 10, 25, 50, 100]
                .map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text("$value"),
              );
            }).toList(),
          ),
          Text("Dòng $firstRow - $lastRow của $rowCount"),
          IconButton(
              onPressed: (pageChangeHandler != null && firstRow != 1)
                  ? () {
                      pageChangeHandler!(currentPage - 1);
                    }
                  : null,
              icon: const Icon(Icons.chevron_left)),
          IconButton(
              onPressed: (pageChangeHandler != null && lastRow < rowCount)
                  ? () {
                      // print(" lastRow ${lastRow}");
                      // print(" currentPage ${currentPage}");
                      pageChangeHandler!(currentPage + 1);
                    }
                  : null,
              icon: const Icon(Icons.chevron_right)),
        ],
      );
    }
    return Container(
        child: Column(
      children: [
        SizedBox(
          height: 25,
        ),
        Text('Không có bản ghi nào'),
      ],
    ));
  }
}

class DynamicTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final int minWidth;
  const DynamicTable(
      {Key? key,
      required this.columns,
      required this.rows,
      this.minWidth = 600})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      if (constraints.maxWidth < 600) {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 5,
                      columns: columns,
                      rows: rows,
                    )))
          ]),
        ]);
      } else {
        return Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
                child: DataTable(
              columnSpacing: 5,
              columns: columns,
              rows: rows,
            ))
          ])
        ]);
      }
    });
  }
}
