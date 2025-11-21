package com.one.touring.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class AdminLoginInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    HttpSession session = request.getSession(false);
	    if (session != null) {
	        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
	        if (loginUser != null && "1".equals(loginUser.getAdmin())) {
	            // 로그인 되어 있고, admin 값이 1이면 접근 허용
	            return true;
	        }
	    }
	    // 관리자 권한 없으면 adminCheck.jsp로 포워딩
	    request.setAttribute("msg", "관리자 권한이 필요합니다. 관리자 권한 신청을 해주세요.");
	    request.setAttribute("url", "/touring/user/myPage"); // 돌아갈 주소
	    request.getRequestDispatcher("/WEB-INF/views/user/adminCheck.jsp").forward(request, response);
	    return false;
	}

}
