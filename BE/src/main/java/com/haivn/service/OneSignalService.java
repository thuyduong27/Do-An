package com.haivn.service;

import com.haivn.dto.OneSignalDto;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Scanner;

@Service
@Slf4j
public class OneSignalService {
    @Value("${onesignal.admin.api_id}")
    private String ADMIN_APP_ID;

    @Value("${onesignal.admin.api_key}")
    private String ADMIN_API_KEY;

    @Value("${onesignal.webapp.api_id}")
    private String WEBAPP_APP_ID;

    @Value("${onesignal.webapp.api_key}")
    private String WEBAPP_API_KEY;

    @Value("${onesignal.mobile.icon}")
    private String MOBILE_ICON;

    public void sendMessageByTags(OneSignalDto dto, String tagName, List<String> tagValues, String userType) {
        String app_id = "";
        String app_key = "";
        if(userType.equals("admin")){
            app_id = ADMIN_APP_ID;
            app_key = ADMIN_API_KEY;
        }
        if(userType.equals("guest")){
            app_id = WEBAPP_APP_ID;
            app_key = WEBAPP_API_KEY;
        }

        try {
            String jsonResponse;

            URL url = new URL("https://onesignal.com/api/v1/notifications");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setUseCaches(false);
            con.setDoOutput(true);
            con.setDoInput(true);

            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            con.setRequestProperty("Authorization", "Basic "+app_key);//REST API
            con.setRequestMethod("POST");

            String strJsonBody = "{"
                    +   "\"app_id\": \""+ app_id +"\","
                    +   "\"data\": {\"foo\": \"bar\"},"
                    +   "\"contents\": {\"en\": \""+ dto.getMessage() +"\"},";
                    if(userType.equals("guest")) {
                        strJsonBody += "\"small_icon\": \""+MOBILE_ICON+"\",";
                        strJsonBody += "\"large_icon\": \""+MOBILE_ICON+"\",";
                    }
                    if(null!=dto.getTitle() && StringUtils.isNotEmpty(dto.getTitle()))
                        strJsonBody +=  "\"headings\": {\"en\": \""+ dto.getTitle() +"\"},";
                    if(null!=dto.getUrl() && StringUtils.isNotEmpty(dto.getUrl())) {
                        strJsonBody += "\"url\": \"" + dto.getUrl() + "\",";
                    }
                    if(null!=dto.getBigImage() && StringUtils.isNotEmpty(dto.getBigImage())) {
                        strJsonBody += "\"chrome_web_image\": \"" + dto.getBigImage() + "\",";
                        strJsonBody += "\"chrome_big_picture\": \"" + dto.getBigImage() + "\",";
                        strJsonBody += "\"adm_big_picture\": \"" + dto.getBigImage() + "\",";
//                        strJsonBody += "\"large_icon\": \"" + dto.getBigImage() + "\",";
                        strJsonBody += "\"big_picture\": \"" + dto.getBigImage() + "\",";
                        strJsonBody += "\"ios_attachments\": {\"id1\": \""+ dto.getBigImage() +"\"},";
                    }

                    strJsonBody +=   "\"filters\": [";
//                    if(tagValues.size()>0)
//                        strJsonBody += "{\"field\": \"tag\",\"key\": \"" + tagName + "\",\"relation\": \"=\",\"value\": \"" + tagValues.get(0) + "\"}";
//                    else {
//                    strJsonBody += "{\"field\": \"tag\",\"key\": \"last_session\",\"relation\": \"=\",\"value\": \"" + val + "\"}";
                        int i = 0;
                        for (String val : tagValues) {
                            strJsonBody += "{\"field\": \"tag\",\"key\": \"" + tagName + "\",\"relation\": \"=\",\"value\": \"" + val + "\"}";
                            if(i++ < tagValues.size() - 1){
                                strJsonBody += ",{\"operator\": \"OR\"},";
                            }
                        }
//                    }
            strJsonBody +=   "]}";


            System.out.println("strJsonBody:\n" + strJsonBody);

            byte[] sendBytes = strJsonBody.getBytes("UTF-8");
            con.setFixedLengthStreamingMode(sendBytes.length);

            OutputStream outputStream = con.getOutputStream();
            outputStream.write(sendBytes);

            int httpResponse = con.getResponseCode();
            System.out.println("httpResponse: " + httpResponse);

            jsonResponse = mountResponseRequest(con, httpResponse);
            System.out.println("jsonResponse:\n" + jsonResponse);



        } catch(Throwable t) {
            t.printStackTrace();
        }
    }

    public void sendMessageToDepartByTags(OneSignalDto dto, int departId, List<String> levelValues) {
        try {
            String jsonResponse;

            URL url = new URL("https://onesignal.com/api/v1/notifications");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setUseCaches(false);
            con.setDoOutput(true);
            con.setDoInput(true);

            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            con.setRequestProperty("Authorization", "Basic "+ADMIN_API_KEY);//REST API
            con.setRequestMethod("POST");

            String strJsonBody = "{"
                    +   "\"app_id\": \""+ ADMIN_APP_ID +"\","
                    +   "\"data\": {\"foo\": \"bar\"},"
                    +   "\"contents\": {\"en\": \""+ dto.getMessage() +"\"},";
            if(null!=dto.getTitle() && StringUtils.isNotEmpty(dto.getTitle()))
                strJsonBody +=  "\"headings\": {\"en\": \""+ dto.getTitle() +"\"},";
            if(null!=dto.getUrl() && StringUtils.isNotEmpty(dto.getUrl())) {
                strJsonBody += "\"url\": \"" + dto.getUrl() + "\",";
            }
            if(null!=dto.getBigImage() && StringUtils.isNotEmpty(dto.getBigImage())) {
                strJsonBody += "\"chrome_web_image\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"chrome_big_picture\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"adm_big_picture\": \"" + dto.getBigImage() + "\",";
//                        strJsonBody += "\"large_icon\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"big_picture\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"ios_attachments\": {\"id1\": \""+ dto.getBigImage() +"\"},";
            }

            strJsonBody +=   "\"filters\": [";
            strJsonBody += "{\"field\": \"tag\",\"key\": \"depart_id\",\"relation\": \"=\",\"value\": \"" + departId + "\"}";
            strJsonBody += ",{\"operator\": \"AND\"},";
//            if(tagValues.size()==1)
//                strJsonBody += "{\"field\": \"tag\",\"key\": \"" + tagName + "\",\"relation\": \"=\",\"value\": \"" + tagValues.get(0) + "\"}";
//            else {
                int i = 0;
                for (String val : levelValues) {
                    strJsonBody += "{\"field\": \"tag\",\"key\": \"level\",\"relation\": \"=\",\"value\": \"" + val + "\"}";
                    if(i++ < levelValues.size() - 1){
                        strJsonBody += ",{\"operator\": \"OR\"},";
                    }
                }
//            }
            strJsonBody +=   "]}";


            System.out.println("strJsonBody:\n" + strJsonBody);

            byte[] sendBytes = strJsonBody.getBytes("UTF-8");
            con.setFixedLengthStreamingMode(sendBytes.length);

            OutputStream outputStream = con.getOutputStream();
            outputStream.write(sendBytes);

            int httpResponse = con.getResponseCode();
            System.out.println("httpResponse: " + httpResponse);

            jsonResponse = mountResponseRequest(con, httpResponse);
            System.out.println("jsonResponse:\n" + jsonResponse);



        } catch(Throwable t) {
            t.printStackTrace();
        }
    }

    public void sendMessageToAllUsers(OneSignalDto dto) {
        try {
            String jsonResponse;

            URL url = new URL("https://onesignal.com/api/v1/notifications");
            HttpURLConnection con = (HttpURLConnection)url.openConnection();
            con.setUseCaches(false);
            con.setDoOutput(true);
            con.setDoInput(true);

            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            con.setRequestProperty("Authorization", "Basic "+ADMIN_API_KEY);//REST API
            con.setRequestMethod("POST");

            String strJsonBody = "{"
                    +   "\"app_id\": \""+ ADMIN_APP_ID +"\","
                    +   "\"included_segments\": [\"All\"],"
                    +   "\"data\": {\"foo\": \"bar\"},";
            if(null!=dto.getTitle() && StringUtils.isNotEmpty(dto.getTitle()))
                strJsonBody +=  "\"headings\": {\"en\": \""+ dto.getTitle() +"\"},";
            if(null!=dto.getUrl() && StringUtils.isNotEmpty(dto.getUrl())) {
                strJsonBody += "\"url\": \"" + dto.getUrl() + "\",";
            }
            if(null!=dto.getBigImage() && StringUtils.isNotEmpty(dto.getBigImage())) {
                strJsonBody += "\"chrome_web_image\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"chrome_big_picture\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"adm_big_picture\": \"" + dto.getBigImage() + "\",";
//                        strJsonBody += "\"large_icon\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"big_picture\": \"" + dto.getBigImage() + "\",";
                strJsonBody += "\"ios_attachments\": {\"id1\": \""+ dto.getBigImage() +"\"},";
            }
            strJsonBody +=   "\"contents\": {\"en\": \""+ dto.getMessage() +"\"}"
                    + "}";


            System.out.println("strJsonBody:\n" + strJsonBody);

            byte[] sendBytes = strJsonBody.getBytes("UTF-8");
            con.setFixedLengthStreamingMode(sendBytes.length);

            OutputStream outputStream = con.getOutputStream();
            outputStream.write(sendBytes);

            int httpResponse = con.getResponseCode();
            System.out.println("httpResponse: " + httpResponse);

            jsonResponse = mountResponseRequest(con, httpResponse);
            System.out.println("jsonResponse:\n" + jsonResponse);

        } catch(Throwable t) {
            t.printStackTrace();
        }
    }

//    public void sendMessageToUser(String title, String message, String userId) {
//        try {
//            String jsonResponse;
//
//            URL url = new URL("https://onesignal.com/api/v1/notifications");
//            HttpURLConnection con = (HttpURLConnection)url.openConnection();
//            con.setUseCaches(false);
//            con.setDoOutput(true);
//            con.setDoInput(true);
//
//            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
//            con.setRequestProperty("Authorization", "Basic "+API_KEY);
//            con.setRequestMethod("POST");
//
//            String strJsonBody = "{"
//                    +   "\"app_id\": \""+ APP_ID +"\","
//                    +   "\"include_player_ids\": [\""+ userId +"\"],"
//                    +   "\"data\": {\"foo\": \"bar\"},"
//                    +   "\"headings\": {\"en\": \""+ title +"\"},"
//                    +   "\"contents\": {\"en\": \""+ message +"\"}"
//                    + "}";
//
//
//            System.out.println("strJsonBody:\n" + strJsonBody);
//
//            byte[] sendBytes = strJsonBody.getBytes("UTF-8");
//            con.setFixedLengthStreamingMode(sendBytes.length);
//
//            OutputStream outputStream = con.getOutputStream();
//            outputStream.write(sendBytes);
//
//            int httpResponse = con.getResponseCode();
//            System.out.println("httpResponse: " + httpResponse);
//
//            jsonResponse = mountResponseRequest(con, httpResponse);
//            System.out.println("jsonResponse:\n" + jsonResponse);
//
//        } catch(Throwable t) {
//            t.printStackTrace();
//        }
//    }

    private String mountResponseRequest(HttpURLConnection con, int httpResponse) throws IOException {
        String jsonResponse;
        if (  httpResponse >= HttpURLConnection.HTTP_OK
                && httpResponse < HttpURLConnection.HTTP_BAD_REQUEST) {
            Scanner scanner = new Scanner(con.getInputStream(), "UTF-8");
            jsonResponse = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            scanner.close();
        }
        else {
            Scanner scanner = new Scanner(con.getErrorStream(), "UTF-8");
            jsonResponse = scanner.useDelimiter("\\A").hasNext() ? scanner.next() : "";
            scanner.close();
        }
        return jsonResponse;
    }
}
