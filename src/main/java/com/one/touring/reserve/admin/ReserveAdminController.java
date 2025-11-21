package com.one.touring.reserve.admin;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.one.touring.reserve.user.ReserveService;
import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;

@Controller
@RequestMapping("/reserveAdmin")
public class ReserveAdminController {
    @Autowired
    private ReserveAdminService reserveAdminService;
    
    @Autowired
    private ReserveService reserveService;

    @GetMapping("/list")
    public String adminList(
            @RequestParam(required=false) String category,
            @RequestParam(required=false) String value,
            Model model) {

        List<ReserveVo> reserveList;
        if(value != null && !value.isEmpty()) {
            switch(category) {
                case "dno":
                    reserveList = reserveAdminService.getReserveByDno(Integer.parseInt(value));
                    break;
                case "uno":
                    reserveList = reserveAdminService.getReserveByUno(Integer.parseInt(value));
                    break;
                case "hno":
                    reserveList = reserveAdminService.getReserveByHno(Integer.parseInt(value));
                    break;
                case "uname":
                	reserveList = reserveAdminService.getReservesByUname(value);
                	break;
                default:
                    reserveList = reserveAdminService.getAllReserves();
            }
        } else {
            reserveList = reserveAdminService.getAllReserves();
        }
        
        model.addAttribute("reserveList", reserveList);
        model.addAttribute("category", category);
        model.addAttribute("value", value);

        return "reserve/adminReserveList";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam("dno") int dno, Model model) {
        ReserveVo reserve = reserveAdminService.getReserveByDno(dno).stream()
                .findFirst().orElse(null);
        if (reserve == null) {
            model.addAttribute("errorMsg", "예약 정보를 찾을 수 없습니다.");
            return "reserve/errorPage";
        }
        UserVo user = reserveAdminService.getUserByUno(reserve.getUno());
        model.addAttribute("reserve", reserve);
        model.addAttribute("user", user);
        return "reserve/adminReserveDetail";
    }
    @GetMapping("/updateForm")
    public String reserveUpdateForm(@RequestParam("dno") int dno, Model model) {
        ReserveVo reserve = reserveService.getReserveDetail(dno);
        model.addAttribute("reserve", reserve);
        return "reserve/reserveUpdate";
    }
    
    @PostMapping("/update")
    public String reserveUpdate(HttpSession session,
                                @RequestParam("dno") int dno,
                                @RequestParam("checkin") String checkin,
                                @RequestParam("checkout") String checkout,
                                @RequestParam("dprice") String dprice) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        if (Integer.parseInt(loginUser.getAdmin()) != 1) return "redirect:/user/login";

        ReserveVo reserve = reserveService.getReserveDetail(dno);
        if (Integer.parseInt(loginUser.getAdmin()) != 1)  return "redirect:/reserve/list";

        reserve.setCheckin(checkin);
        reserve.setCheckout(checkout);
        reserve.setDprice(dprice);
        reserveService.updateReserve(reserve);

        return "redirect:/reserveAdmin/detail?dno=" + dno;
    }
    
    @GetMapping("/cancel")
    public String reserveCancel(@RequestParam("dno") int dno) {
        reserveService.getReserveDetail(dno);
        reserveService.cancelReserve(dno);
        return "redirect:/reserveAdmin/list";
    }
}
