package com.haivn.authenticate;

import com.haivn.common_api.HethongNguoidungToken;
import com.haivn.service.TokenService;
import io.jsonwebtoken.ExpiredJwtException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Set;

@WebFilter("/*")
@Component
@Slf4j
//@Order(2)
public class JwtRequestFilter extends OncePerRequestFilter {
    private static final String[] HEADERS_TO_TRY = {
            "X-Forwarded-For",
            "Proxy-Client-IP",
            "WL-Proxy-Client-IP",
            "HTTP_X_FORWARDED_FOR",
            "HTTP_X_FORWARDED",
            "HTTP_X_CLUSTER_CLIENT_IP",
            "HTTP_CLIENT_IP",
            "HTTP_FORWARDED_FOR",
            "HTTP_FORWARDED",
            "HTTP_VIA",
            "REMOTE_ADDR" };

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private TokenService tokenService;

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        MultiReadHttpServletRequest wrapper = new MultiReadHttpServletRequest(request);

        String allowOrigin = "*";
        String origin = wrapper.getHeader("origin");
        if (origin != null && !origin.isEmpty()) {
            allowOrigin = origin;
        }
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setHeader("Access-Control-Allow-Origin", allowOrigin);
        response.setHeader("Access-Control-Allow-Headers", "authorization, x-auth-token, Origin, Content-Type, Accept, X-Requested-With, remember-me");
        response.setHeader("Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, HEAD");
        response.setHeader("Access-Control-Max-Age", "3600");
        response.setHeader("Content-Type", "application/json; charset=utf-8");
        response.setHeader("Content-Type", "multipart/form-data");
        response.setHeader("Access-Control-Expose-Headers", "Authorization, Content-Disposition");

        try {
            final String authorizationHeader = wrapper.getHeader("Authorization");
//            logger.info("Authorization Token:" + authorizationHeader);
            UserPrincipal user = null;
            HethongNguoidungToken token = null;
            if (StringUtils.hasText(authorizationHeader) && authorizationHeader.startsWith("aam ")) {
                String jwt = authorizationHeader.substring(4);
                user = jwtUtil.getUserFromToken(jwt);
                token = tokenService.findByToken(jwt);
            } else {
                logger.warn("Token does not begin with 'aam '");
            }

            if (null != user && null != token) {
                if(token.getTokenexpdate().after(new Timestamp(System.currentTimeMillis()))) {
                    Set<GrantedAuthority> authorities = new HashSet<>();
                    user.getAuthorities().forEach(p -> authorities.add(new SimpleGrantedAuthority((String) p)));
                    UsernamePasswordAuthenticationToken authentication =
                            new UsernamePasswordAuthenticationToken(user, null, authorities);
                    authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(wrapper));
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }
                else
                    throw new AccessDeniedException("Access Token expired, please login again!");
            }
            else
                logger.info("User or Token is Null. Failed to set user authentication in security context.");
        }catch (ExpiredJwtException ex) {
            String isRefreshToken = wrapper.getHeader("isRefreshToken");
            String requestURL = wrapper.getRequestURL().toString();
            // allow for Refresh Token creation if following conditions are true.
            if (isRefreshToken != null && isRefreshToken.equals("true") && requestURL.contains("refreshtoken")) {
                allowForRefreshToken(ex, wrapper);
            } else {
                wrapper.setAttribute("exception", ex);
//                throw new AccessDeniedException("TOKEN Expired, please login again!" + ex.getMessage());
            }
        }
        catch (BadCredentialsException ex) {
            wrapper.setAttribute("exception", ex);
        } catch (Exception ex) {
            System.out.println(ex);
        }

        filterChain.doFilter(wrapper, response);
        logPayLoad(wrapper);
    }

    private void allowForRefreshToken(ExpiredJwtException ex, HttpServletRequest request) {
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                null, null, null);
        SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
        request.setAttribute("claims", ex.getClaims());
    }

    public String getClientIpAddress(HttpServletRequest request)
    {
        for (String header : HEADERS_TO_TRY) {
            String ip = request.getHeader(header);
            if (ip != null && ip.length() != 0 && !"unknown".equalsIgnoreCase(ip)) {
                return ip;
            }
        }
        return request.getRemoteAddr();
    }

    private void logPayLoad(MultiReadHttpServletRequest request) {
        final StringBuilder params = new StringBuilder();
        final String method = request.getMethod().toUpperCase();
        final String ipAddress = getClientIpAddress(request);
        final String userAgent = request.getHeader("User-Agent");
        log.info(String.format("============Begin request=========="));
        log.info(String.format("Access from ip:%s;ua:%s", ipAddress, userAgent));
        log.info(String.format("Method : %s requestUri %s", method, request.getRequestURI()));
        params.append("Query Params:").append(System.lineSeparator());
        Enumeration<String> parameterNames = request.getParameterNames();

        for (; parameterNames.hasMoreElements();) {
            String paramName = parameterNames.nextElement();
            String paramValue = request.getParameter(paramName);
            if ("password".equalsIgnoreCase(paramName) || "pwd".equalsIgnoreCase(paramName)) {
                paramValue = "*****";
            }
            params.append("---->").append(paramName).append(": ").append(paramValue).append(System.lineSeparator());
        }
        log.info(params.toString());
        /** request body */

        if ("POST".equals(method) || "PUT".equals(method) || "DELETE".equals(method)) {
            try {
                log.info(IOUtils.toString(request.getInputStream()));
            } catch (IOException e) {
                log.error(e.getMessage(), e);
            }
        }
        log.info(String.format("============End-request=========="));
    }
}

