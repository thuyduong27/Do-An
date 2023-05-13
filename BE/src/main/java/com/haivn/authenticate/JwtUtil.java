package com.haivn.authenticate;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.nimbusds.jose.*;
import com.nimbusds.jose.crypto.MACSigner;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jose.shaded.json.JSONObject;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.sql.Timestamp;
import java.text.ParseException;
import java.util.Date;
import java.util.Map;


@Component
public class JwtUtil {
    private static Logger logger = LoggerFactory.getLogger(JwtUtil.class);
//    private static final String USER = "aam";
//    private static final String SECRET = "BMD2cGEhIKi3Td1Egg38CEq7JxxlHqQW3fHDLqZlZs1sE4caDwqu46ELSTfr43o34mNfeV8tyUJUdCAA7VfAr7cGXZF6AaMGv6OGEjFjPpjYHLe3BXAK5z8b7MeqeWo2uz39Bp6OLgUKVaKLUs7hx8Zqy84F5qkDwA7hS7y3bLTUMEFDcHYfzGeQfPfirtZ0fmRKPitorUAGZVTSsUqmqD6IWtPp6K8tnVEvqIgOUngZken0AwpdJKcCkYjA5PLx";

    @Value("${jwt.aam.user}")
    private String USER;

    @Value("${jwt.aam.secret}")
    private String SECRET;

    @Value("${jwt.aam.jwtExpirationMs}")
    private String EXPIRED_TIME;

    @Value("${jwt.aam.jwtRefreshExpirationMs}")
    private String REFRESH_TIME;

    public String generateToken(UserPrincipal user) {
        String token = null;
        try {
            JWTClaimsSet.Builder builder = new JWTClaimsSet.Builder();
            builder.claim(USER, user);
            builder.expirationTime(generateExpirationDate());
            JWTClaimsSet claimsSet = builder.build();
            SignedJWT signedJWT = new SignedJWT(new JWSHeader(JWSAlgorithm.HS256), claimsSet);
            JWSSigner signer = new MACSigner(SECRET.getBytes());
            signedJWT.sign(signer);
            token = signedJWT.serialize();
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return token;
    }

    public String generateRefreshToken(Map<String, Object> claims, String subject) {
        return Jwts.builder().setClaims(claims).setSubject(subject).setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Timestamp(System.currentTimeMillis() + Long.parseLong(REFRESH_TIME)))
                .signWith(SignatureAlgorithm.HS256, SECRET).compact();

    }

    //86400000: 24H
    //28800000:8h
    //180000: 3'
    public Timestamp generateExpirationDate() {
        return new Timestamp(System.currentTimeMillis() + Long.parseLong(EXPIRED_TIME));
    }

    public JWTClaimsSet getClaimsFromToken(String token) {
        JWTClaimsSet claims = null;
        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            JWSVerifier verifier = new MACVerifier(SECRET.getBytes());
            if (signedJWT.verify(verifier)) {
                claims = signedJWT.getJWTClaimsSet();
            }
        } catch (ParseException | JOSEException e) {
            logger.error(e.getMessage());
        }
        return claims;
    }

    public UserPrincipal getUserFromToken(String token) {
        UserPrincipal user = null;
        try {
            JWTClaimsSet claims = getClaimsFromToken(token);
            if (claims != null && isTokenExpired(claims)) {
                JSONObject jsonObject = (JSONObject) claims.getClaim(USER);
                user = new ObjectMapper().readValue(jsonObject.toJSONString(), UserPrincipal.class);
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
        return user;
    }

    private Date getExpirationDateFromToken(JWTClaimsSet claims) {
        return claims != null ? claims.getExpirationTime() : new Date();
    }

    private boolean isTokenExpired(JWTClaimsSet claims) {
        return getExpirationDateFromToken(claims).after(new Date());
    }
}
