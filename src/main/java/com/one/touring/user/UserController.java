package com.one.touring.user;

import java.util.List;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.one.touring.hotel.HotelVo;

@Controller
@RequestMapping("/user")
public class UserController {
   @Autowired
   UserService userService;
   
   @GetMapping("/mylike")
   public String myLikeList(Model model, HttpSession session) {
      UserVo loginUser = (UserVo) session.getAttribute("loginSession");
       int uno = loginUser.getUno();
       List<HotelVo> likeList = userService.getLikedHotels(uno);
       model.addAttribute("likeList", likeList);
       return "user/MyLikeList";
   }
   
   @GetMapping("/login")
   public String loginUser() {
      return "user/login";
   }
   
   @PostMapping("/loginOk")
   public String loginOkUser(HttpSession httpSession,
                        @RequestParam("id") String id,
                        @RequestParam("pw") String pw) {
      UserVo result=userService.loginOk(id,pw);
      if(result==null) {
         return "user/loginErr";
      }
      httpSession.setAttribute("loginSession", result);
      return "home";
   }
   
   @GetMapping("/insert")
   public String insertUser() {
      return "user/insertUser";
   }
   
   @PostMapping("/insertOk")
   public String insertOkUser(UserVo vo) {
      userService.insert(vo);
      return "redirect:/user/login";
   }
   @GetMapping("/list")
   public String listUser(Model model) {
      model.addAttribute("userList",userService.selectAll());
      return "user/listUser";
   }   
   
   @GetMapping("/logout")
   public String logoutUser(HttpSession httpSession) {
      httpSession.invalidate();
      return "home";
   }      
   
   @GetMapping("/myPage")
   public String myPageUser() {
      return "user/myPage";
   }   
   
   @GetMapping("/detail")
   public String detailUser(@RequestParam("uno") int uno, Model model) {
      model.addAttribute("user",userService.select_uno(uno));
      return "user/detailUser";
   }
   
   @GetMapping("/update")
   public String updateUser(@RequestParam("uno") int uno, HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        UserVo user = userService.select_uno(uno);
        if (user.getUno() != loginUser.getUno()) {
            return "redirect:/user/myPage";
        }
      return "user/updateUser";
   }
   
   @PostMapping("/updateOk")
   public String updateOkUser(@RequestParam("uno") int uno, HttpSession session, UserVo userVo) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        UserVo user = userService.select_uno(uno);
        if (user.getUno() != loginUser.getUno()) {
            return "redirect:/user/myPage";
        }
      userService.update(userVo);
      session.setAttribute("loginSession", userVo);
      return "home";
   }
   
   @GetMapping("/delete")
   public String deleteUser(@RequestParam("uno") int uno,HttpSession httpSession) {
      System.out.println("회원번호 : "+uno+" 삭제됨");
      userService.delete(uno);
       UserVo loginUser=(UserVo)httpSession.getAttribute("loginSession");
       if (loginUser != null && loginUser.getUno() == uno) {
           httpSession.invalidate();   // 자진 탈퇴 시 로그아웃 후 홈으로
           return "home";
       } else {
           return "redirect:/user/list";   // 관리자가 삭제한 경우 리스트로
       }
   }
   
   @GetMapping("/id-check")
   @ResponseBody
   public String checkId(@RequestParam String id) {
       boolean exists = userService.idCk(id);
       return "exists=" + exists;
   }
   
   @GetMapping("/adminTry")
   public String adminTry(@RequestParam("uno") int uno,HttpSession httpSession) {
      userService.adminTry(uno);
      UserVo loginSession=(UserVo)httpSession.getAttribute("loginSession");
      loginSession.setAdmin("2");
      httpSession.setAttribute("loginSession", loginSession);
      return "redirect:/user/myPage";
   }
   
   @GetMapping("/adminTryOk")
   public String adminTryOk(@RequestParam("uno") int uno) {
      userService.adminTryOk(uno);
      return "redirect:/user/list";
   }
   
   @GetMapping("/adminTryNo")
   public String adminTryNo(@RequestParam("uno") int uno, HttpSession httpSession) {
       userService.adminTryNo(uno);
       UserVo loginSession = (UserVo) httpSession.getAttribute("loginSession");
       if (loginSession != null && loginSession.getUno() == uno) {
           loginSession.setAdmin("0");
           httpSession.setAttribute("loginSession", loginSession);
           return "redirect:/user/myPage";
       } else {
           return "redirect:/user/list";
       }
   }
   
   @GetMapping("/updatePw")
   public String updatePw() {
      return "user/updateUserPw";
   }
   
   @PostMapping("/pw-check")
   @ResponseBody
   public String pwCheckAjax(@RequestParam String id, @RequestParam String pw) {
       boolean isMatch = userService.pwCheck(id, pw);
       return "match=" + isMatch;
   }
   
   @PostMapping("/updatePwOk")
   public String updatePwOk(@RequestParam("id") String id,@RequestParam("pw2") String pw,
         HttpSession session, Model model) {
      userService.updatePw(id, pw);
       session.invalidate();
        model.addAttribute("msg", "비밀번호가 변경되었습니다. 다시 로그인 해주세요.");
        model.addAttribute("url", "/user/login");
       return "alert";
   }
   
   
}
