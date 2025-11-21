package com.one.touring.review;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.one.touring.reserve.user.ReserveService;
import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;

@Controller
@RequestMapping("/review")
public class ReviewController {

    @Autowired
    private ReviewService reviewService;
    
    @Autowired
    private ReserveService reserveService;

	@GetMapping("/delete")
	public String deleteReview(@RequestParam("rno") int rno, HttpSession session) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        ReviewVo reviewVo = reviewService.detailReview(rno);
        ReserveVo reserve = reserveService.getReserveDetail(reviewVo.getDno());
        if (reserve.getUno() != loginUser.getUno()) {
            return "redirect:/review/myReview";
        }
	    reviewService.deleteReview(rno);   
	    return "redirect:/review/myReview";
	}
    
    @GetMapping("/myReview")
    public String myReviewList(HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        int uno = loginUser.getUno();
        List<ReviewVo> reviewList = reviewService.myReviewList(uno);
        for (ReviewVo review : reviewList) {
            ReserveVo reserve = reserveService.getReserveDetail(review.getDno());
            boolean canUpdate = reserve != null 
                                && reserve.getCheckout() != null
                                && canReviewCheck(reserve.getCheckout());
            review.setCanUpdateReview(canUpdate);
        }
        model.addAttribute("reviewList", reviewList);
        return "review/myReviewList";
    }
    
    // 리뷰 update
    @GetMapping("/update")
    public String updateReview(@RequestParam("rno") int rno, Model model, HttpSession session) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        ReviewVo reviewVo = reviewService.detailReview(rno);
        ReserveVo reserve = reserveService.getReserveDetail(reviewVo.getDno());
        if (reserve.getUno() != loginUser.getUno()) {
            return "redirect:/review/myReview";
        }
        // 7일 제한 체크
        reviewVo.setCanUpdateReview(canReviewCheck(reserve.getCheckout()));
        model.addAttribute("review", reviewVo);
        return "review/reviewUpdate";
    }

    // 체크아웃 이후 7일 체크
	private boolean canReviewCheck(String checkout) {
	    if (checkout == null) return false;
	    java.time.LocalDate checkoutDate = java.time.LocalDate.parse(checkout);
	    java.time.LocalDate today = java.time.LocalDate.now();
	    return !today.isBefore(checkoutDate) && !today.isAfter(checkoutDate.plusDays(7));
	}

    // 리뷰 updateOk
    @PostMapping("/updateOk")
    public String updateReviewOk(@ModelAttribute ReviewVo reviewVo, HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession"); // 로그인 사용자 정보
    	ReserveVo reserve = reserveService.getReserveDetail(reviewVo.getDno());
        if (reserve.getUno() != loginUser.getUno()) {
            return "redirect:/review/myReview";
        }
    	if (!canReviewCheck(reserve.getCheckout())) {
    	    return "redirect:/review/myReview";
    	}
        // 리뷰 업데이트
        reviewService.updateReview(reviewVo);
        return "redirect:/review/myReview";
    }
    
    // 리뷰 상세보기 // 사용하지 않음
//    @GetMapping("/detail")
//    public String detailReview(@RequestParam("rno") int rno, Model model) {
//        ReviewVo review = reviewService.detailReview(rno);
//        ReserveVo reserve = reserveService.getReserveDetail(review.getDno());
//        boolean canUpdate = reserve != null && reserve.getCheckout() != null
//                            && canReviewCheck(reserve.getCheckout());
//        review.setCanUpdateReview(canUpdate);
//        model.addAttribute("review", review);
//        return "review/reviewDetail";
//    }
    
    @GetMapping("/insert")
    public String insertReview(@RequestParam("dno") int dno, HttpSession session, Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        if (loginUser == null) {
            return "redirect:/user/login";
        }
        ReserveVo reserve = reserveService.getReserveDetail(dno);
        if (!canReviewCheck(reserve.getCheckout())) {
            return "redirect:/reserve/list";
        }
        model.addAttribute("dno", dno);
        return "review/reviewInsert";
    }

    @PostMapping("/insertOk")
    public String insertReviewOk(@ModelAttribute ReviewVo reviewVo, HttpSession session) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        if (loginUser == null) {
            return "redirect:/user/login";
        }
        ReserveVo reserve = reserveService.getReserveDetail(reviewVo.getDno());
        if (!canReviewCheck(reserve.getCheckout())) {
            return "redirect:/reserve/list";
        }
        reviewVo.setUno(loginUser.getUno());
        reviewService.insertReview(reviewVo);
        return "redirect:/reserve/list";
    }
    
    @GetMapping("/list")
    public String reviewList(@RequestParam("hno") int hno, Model model) {
        List<ReviewVo> reviewList = reviewService.getReviewsByHotelHno(hno);
        model.addAttribute("reviewList", reviewList);
        return "review/reviewList";
    }
}
