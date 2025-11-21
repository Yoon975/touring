package com.one.touring.reserve.user;

import com.one.touring.review.ReviewService;
import com.one.touring.user.UserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;
import java.util.*;
import java.text.SimpleDateFormat;

@Controller
@RequestMapping("/reserve")
public class ReserveController {

    @Autowired
    private ReserveService reserveService;

    @Autowired
    private ReviewService reviewService;

    @GetMapping("/list")
    public String reserveList(HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        List<ReserveVo> reserveList = reserveService.getReserveList(loginUser.getUno());

        String todayStr = java.time.LocalDate.now().toString();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date today = new Date();

        List<ReserveVo> upcomingList = new ArrayList<>(); // 다가올 예약
        List<ReserveVo> pastList = new ArrayList<>();     // 지난 예약

        for (ReserveVo reserve : reserveList) {
            try {
                Date checkout = sdf.parse(reserve.getCheckout());
                boolean hasReview = reviewService.reviewsByDno(reserve.getDno());
                reserve.setHasReview(hasReview);

                // 체크아웃이 지났는지 여부
                if (checkout.before(today)) {
                    pastList.add(reserve);
                } else {
                    upcomingList.add(reserve);
                }
                // 후기 작성 가능 여부
                if (reserve.getCheckout().compareTo(todayStr) <= 0) {
                    long diff = today.getTime() - checkout.getTime();
                    long diffDays = diff / (1000 * 60 * 60 * 24);
                    if (!hasReview && diffDays <= 7) {
                        reserve.setCanWriteReview(true);
                    } else {
                        reserve.setCanWriteReview(false);
                    }
                } else {
                    reserve.setCanWriteReview(false);
                }
                // 이용 전 여부
                reserve.setCanUse(checkout.after(today));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        model.addAttribute("upcomingList", upcomingList);
        model.addAttribute("pastList", pastList);

        return "reserve/reserveList";
    }

 // 예약 상세 조회 (GET)
    @GetMapping("/detail")
    public String reserveDetail(@RequestParam("dno") int dno, HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        ReserveVo reserve = reserveService.getReserveDetail(dno);
        // 다른 사용자가 접근하면 리스트로 리다이렉트
        if (reserve.getUno() != loginUser.getUno()) return "redirect:/reserve/list";
        model.addAttribute("todayStr", java.time.LocalDate.now().toString());
        model.addAttribute("reserve", reserve);
        return "reserve/reserveDetail";
    }

 // 예약 등록 폼
    @GetMapping("/insertForm")
    public String reserveInsertForm(@RequestParam("hno") int hno, Model model) {
        // 호텔 정보
        model.addAttribute("hotel", reserveService.detailHotel(hno));

        // SQL 기반으로 계산된 예약 불가 날짜 전달
        List<String> bookedDates = reserveService.getBookedDates(hno);
        model.addAttribute("bookedDatesJson", bookedDates); // JSP에서 flatpickr disable용

        return "reserve/reserveInsert";
    }


    // 예약 등록 처리
    @PostMapping("/insert")
    public String reserveInsert(HttpSession session, ReserveVo reserveVo, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        reserveVo.setUno(loginUser.getUno());

        try {
            // SQL 기반 예약 가능 체크 + 등록
            reserveService.insertReserve(reserveVo);
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("hotel", reserveService.detailHotel(reserveVo.getHno()));
            return "reserve/reserveInsert";
        }

        return "redirect:/reserve/list";
    }

    // 예약 수정 폼
    @GetMapping("/updateForm")
    public String reserveUpdateForm(@RequestParam("dno") int dno, HttpSession session, Model model) {
    	UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        ReserveVo reserve = reserveService.getReserveDetail(dno);
        model.addAttribute("reserve", reserve);
        if (reserve.getUno() != loginUser.getUno()) {
            return "redirect:/review/myReview";
        }
        // 자신 예약 제외하고 bookedDates 조회
        List<String> bookedDates = reserveService.getBookedDates(reserve.getHno(), reserve.getDno());
        model.addAttribute("bookedDatesJson", bookedDates);

        return "reserve/reserveUpdate";
    }

 // 예약 수정 처리
    @PostMapping("/update")
    public String reserveUpdate(HttpSession session,
                                @RequestParam("dno") int dno,
                                @RequestParam("checkin") String checkin,
                                @RequestParam("checkout") String checkout,
                                @RequestParam("dprice") String dprice,
                                Model model) {

        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        ReserveVo reserve = reserveService.getReserveDetail(dno);

        if (reserve.getUno() != loginUser.getUno()) return "redirect:/reserve/list";

        reserve.setCheckin(checkin);
        reserve.setCheckout(checkout);
        reserve.setDprice(dprice);

        try {
            // SQL 기반 예약 가능 체크 + 수정
            reserveService.updateReserve(reserve);
        } catch (RuntimeException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("reserve", reserve);
            return "reserve/reserveUpdate";
        }

        return "redirect:/reserve/detail?dno=" + dno;
    }

    // 삭제
    @GetMapping("/cancel")
    public String reserveCancel(HttpSession session, @RequestParam("dno") int dno) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");

        ReserveVo reserve = reserveService.getReserveDetail(dno);
        if (reserve.getUno() != loginUser.getUno()) return "redirect:/reserve/list";

        reserveService.cancelReserve(dno);
        return "redirect:/reserve/list";
    }
    
}
