package com.haivn.handler;

import com.haivn.authenticate.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.BeanWrapper;
import org.springframework.beans.BeanWrapperImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.text.Normalizer;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {
    public static BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
    private static Logger logger = LoggerFactory.getLogger(JwtUtil.class);

    public static String asJsonString(final Object obj) {
        try {
            return new ObjectMapper().writeValueAsString(obj);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static String removeUnicode(String s) {
        String temp = Normalizer.normalize(s, Normalizer.Form.NFD);
        Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
        return pattern.matcher(temp).replaceAll("")
                .replaceAll("Đ", "D")
                .replaceAll("đ", "d");
    }

    public static boolean isPhone(String value) {
        if (value.length() < 9)
            return false;

        try {
            Pattern pattern = Pattern.compile("^[0-9]*$");
            Matcher matcher = pattern.matcher(value);
            return matcher.matches();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public static boolean isEmail(String email) {
        try {
            String emailPattern = "^[\\w!#$%&’*+/=?`{|}~^-]+(?:\\.[\\w!#$%&’*+/=?`{|}~^-]+)*@(?:[a-zA-Z0-9-]+\\.)+[a-zA-Z]{2,6}$";
            Pattern regex = Pattern.compile(emailPattern);
            Matcher matcher = regex.matcher(email);
            return matcher.find();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    public static boolean isDomain(String domain) {
        try {
            String domainPattern = "@(http)?(s)?(://)?(([a-zA-Z])([-\\w]+\\.)+([^\\s\\.]+[^\\s]*)+[^,.\\s])@";
            Pattern regex = Pattern.compile(domainPattern);
            Matcher matcher = regex.matcher(domain);
            return matcher.find();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return false;
    }

    //Xử lý các trường thông tin bị null
    public static String[] getNullPropertyNames (Object source, List<String> nullAllowFields) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for(java.beans.PropertyDescriptor pd : pds) {
            if(!nullAllowFields.contains(pd.getName())) {
                Object srcValue = src.getPropertyValue(pd.getName());
                if (srcValue == null) emptyNames.add(pd.getName());
            }
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    //Xử lý các trường thông tin bị null
    public static String[] getNullPropertyNames (Object source, String nullAllowField) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for(java.beans.PropertyDescriptor pd : pds) {
            if(!pd.getName().equals(nullAllowField)) {
                Object srcValue = src.getPropertyValue(pd.getName());
                if (srcValue == null) emptyNames.add(pd.getName());
            }
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    public static String[] getNullPropertyNames (Object source) {
        final BeanWrapper src = new BeanWrapperImpl(source);
        java.beans.PropertyDescriptor[] pds = src.getPropertyDescriptors();

        Set<String> emptyNames = new HashSet<String>();
        for(java.beans.PropertyDescriptor pd : pds) {
            Object srcValue = src.getPropertyValue(pd.getName());
            if (srcValue == null) emptyNames.add(pd.getName());
        }
        String[] result = new String[emptyNames.size()];
        return emptyNames.toArray(result);
    }

    //Chuyển chuỗi kí tự sang SQL Date
    public static java.sql.Date StringToSqlDate(String sDate){
        java.sql.Date sqlDate = null;
        try
        {
            Date mydate = new SimpleDateFormat("dd/MM/yyyyy").parse(sDate);
            sqlDate =  new java.sql.Date(mydate.getTime());
        }
        catch (ParseException e) {
            System.out.println(e.getMessage());
        }
        return sqlDate;
    }

    public static String convertTimestampToStringDate(Long tsp){
        SimpleDateFormat sf = new SimpleDateFormat("HH:mm dd-MM-yyyy");
        Date date = new Date(tsp);
        return sf.format(date);
    }

    //Lấy 1 UUID ngẫu nhiên
    public static String getUUID(){
        UUID uuid = UUID.randomUUID();
        return uuid.toString();
    }

    //Chuyển chuỗi kí tự sang UUID
    public static UUID convertStringToUUID(String strUUID){
        UUID uuid = UUID.randomUUID();
        UUID sameUuid = UUID.fromString(strUUID);
        return sameUuid.equals(uuid)?sameUuid:null;
    }

    //Lấy chuỗi 6 kí tự ngẫu nhiên được mã hóa BCrypt
    public static String getBCryptedPassword() {
        String randomPwd = getRandomString(6);
        return getBCryptedPassword(randomPwd);
    }

    //Mã hóa kí tự theo BCrypt
    public static String getBCryptedPassword(String pwd) {
        return bCryptPasswordEncoder.encode(pwd);
    }

    //Lấy chuỗi kí tự ngẫu nhiên theo độ dài
    public static String getRandomString(int len) {
        String SALTCHARS = "AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890";
        StringBuilder salt = new StringBuilder();
        Random rnd = new Random();
        while (salt.length() < len) { // length of the random string.
            int index = (int) (rnd.nextFloat() * SALTCHARS.length());
            salt.append(SALTCHARS.charAt(index));
        }
        return salt.toString();
    }

    public static boolean isMatchRegex(String regex, String content){
        Pattern pattern = Pattern.compile(regex);
        return pattern.matcher(content).matches();
    }

    public static String getSiteURL(HttpServletRequest request) {
        String siteURL = request.getRequestURL().toString();
        return siteURL.replace(request.getServletPath(), "");
    }

    //Tạo thư mục
    public static void mkdirs(String destPath) {
        File file = new File(destPath);
        if (!file.exists() && !file.isDirectory()) {
            file.mkdirs();
        }
    }

    //Tìm file trong thư mục, quét cả thư mục con
    public static File searchFile(File file, String search) {
        if (file.isDirectory()) {
            File[] arr = file.listFiles();
            for (File f : arr) {
                File found = searchFile(f, search);
                if (found != null)
                    return found;
            }
        } else {
            if (file.getName().equals(search)) {
                return file;
            }
        }
        return null;
    }
}
