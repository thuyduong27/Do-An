package com.haivn.handler;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;
import org.springframework.web.multipart.MultipartFile;

import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

public class ExcelToJsonConverter {
    private ObjectMapper mapper = new ObjectMapper();

    public JsonNode excelToJson(MultipartFile excel) {
        JsonNode jnode = null;
        try {
            XSSFWorkbook workBook = new XSSFWorkbook(excel.getInputStream());
            XSSFSheet workSheet = workBook.getSheetAt(0);
            List<JSONObject> dataList = new ArrayList<>();
            XSSFRow header = workSheet.getRow(1);
            for(int i=2;i<workSheet.getPhysicalNumberOfRows();i++) {
                XSSFRow row = workSheet.getRow(i);
                JSONObject rowJsonObject = new JSONObject();
                for(int j=0; j<9;j++) {
                    String columnName = header.getCell(j).toString();
                    Cell c = row.getCell(j);
                    String columnValue = row.getCell(j).toString();
                    if (c.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(c)) {
                        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
                        Date cDate = c.getDateCellValue();
                        columnValue = df.format(cDate);
                    }
                    if(columnValue!=""){
                        rowJsonObject.put(columnName, columnValue);
                    }
                }
                dataList.add(rowJsonObject);
            }
            Gson gson = new Gson();
            jnode = mapper.readValue(gson.toJson(dataList), JsonNode.class);
            return jnode;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return jnode;
    }

    public JsonNode excelToJson2(MultipartFile excel) {
        JsonNode jnode = null;
        try {
            XSSFWorkbook workBook = new XSSFWorkbook(excel.getInputStream());
            XSSFSheet workSheet = workBook.getSheetAt(0);
            List<JSONObject> dataList = new ArrayList<>();
            XSSFRow header = workSheet.getRow(1);
            DataFormatter formatter = new DataFormatter();
            for(int i=1;i<workSheet.getPhysicalNumberOfRows();i++) {
                XSSFRow row = workSheet.getRow(i);
                JSONObject rowJsonObject = new JSONObject();
                for(int j=0; j<row.getPhysicalNumberOfCells();j++) {
                    String columnName = header.getCell(j).toString();
                    Cell c = row.getCell(j);
                    String columnValue = formatter.formatCellValue(c);
                    if (c.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(c)) {
                        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                        Date cDate = c.getDateCellValue();
                        columnValue = df.format(cDate);
                    }

                    rowJsonObject.put(columnName, columnValue);
                }
                dataList.add(rowJsonObject);
            }
            Gson gson = new Gson();
            jnode = mapper.readValue(gson.toJson(dataList), JsonNode.class);
            return jnode;
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return jnode;
    }

    public JsonNode excelToJsonKeepCode(MultipartFile excel) {
        JsonNode jnode = null;
        try {
            XSSFWorkbook workBook = new XSSFWorkbook(excel.getInputStream());
            XSSFSheet workSheet = workBook.getSheetAt(0);
            List<JSONObject> dataList = new ArrayList<>();
            XSSFRow header = workSheet.getRow(2);
            DataFormatter formatter = new DataFormatter();
            for(int i=2;i<workSheet.getPhysicalNumberOfRows();i++) {
                XSSFRow row = workSheet.getRow(i);
                JSONObject rowJsonObject = new JSONObject();
                for(int j=0; j<row.getPhysicalNumberOfCells();j++) {
                    String columnName = header.getCell(j).toString();
                    Cell c = row.getCell(j);
                    String columnValue = formatter.formatCellValue(c);
                    if (c.getCellType() == CellType.NUMERIC && DateUtil.isCellDateFormatted(c)) {
                        DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
                        Date cDate = c.getDateCellValue();
                        columnValue = df.format(cDate);
                    }
                    rowJsonObject.put(columnName, columnValue);
                }
                dataList.add(rowJsonObject);
            }
            Gson gson = new Gson();
            jnode = mapper.readValue(gson.toJson(dataList), JsonNode.class);
            return jnode;
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        return jnode;
    }

    public void writeData2JsonFile(List<JSONObject> dataList) {
        Gson gson = new Gson();
        try {
            FileWriter file = new FileWriter("C:\\Users\\user\\Downloads\\Excel2Json\\src\\main\\resources\\data.json");
            file.write(gson.toJson(dataList));
            file.close();
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }

    }
}
