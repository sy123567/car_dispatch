package filter;

import jakarta.servlet.*;
import java.io.IOException;

/**
 * 字符编码过滤器
 * 统一设置请求和响应的UTF-8编码
 */
public class CharacterEncodingFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        jakarta.servlet.http.HttpServletRequest req = (jakarta.servlet.http.HttpServletRequest) request;
        String path = req.getRequestURI();
        
        // If it is a static resource, bypass encoding filter completely to let Tomcat handle MIME types natively
        if (path.contains("/css/") || path.contains("/js/") || path.contains("/images/") || 
            path.endsWith(".css") || path.endsWith(".js") || path.endsWith(".png") || path.endsWith(".jpg")) {
            chain.doFilter(request, response);
            return;
        }

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
