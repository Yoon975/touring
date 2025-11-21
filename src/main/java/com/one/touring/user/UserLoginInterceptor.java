package com.one.touring.user;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

public class UserLoginInterceptor implements HandlerInterceptor {
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session=request.getSession(false);
		if (session!=null) {
			Object user=session.getAttribute("loginSession");
			if (user!=null)   //로그인 된 경우
				return true;
		}
		//로그인 안된 경우
		request.setAttribute("msg", "로그인 후 이용 가능한 서비스입니다.");
	    request.setAttribute("url", "/touring/user/login"); // 돌아갈 주소
	    request.getRequestDispatcher("/WEB-INF/views/user/userCheck.jsp").forward(request, response);
		return false;
	}

}
