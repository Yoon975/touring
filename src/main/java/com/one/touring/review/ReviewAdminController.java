package com.one.touring.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.one.touring.reserve.user.ReserveService;
import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;

@Controller
@RequestMapping("/reviewAdmin")
public class ReviewAdminController {

    @Autowired
    private ReviewService reviewService;
    
    // 리뷰 상세보기
    @GetMapping("/detail")
    public String detailReview(@RequestParam("rno") int rno, Model model) {
        ReviewVo review = reviewService.detailReview(rno);
        model.addAttribute("review", review);
        return "review/adminReviewDetail";
    }
    
    // 관리자 리뷰 리스트
    @GetMapping("/list")
    public String reviewList(@RequestParam(value="category", required=false) String category,
                             @RequestParam(value="value", required=false) String value,
                             Model model) {

        System.out.println("category = " + category);
        System.out.println("value = " + value);
        List<ReviewVo> reviewList;

        try {
            if (category != null && value != null && !value.trim().isEmpty()) {
                reviewList = reviewService.searchReviews(category, value);
            } else {
                reviewList = reviewService.AllReviews(); // 전체 리뷰 조회
            }
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
            reviewList = reviewService.AllReviews(); // 전체 목록 다시 보여줌
        }

        model.addAttribute("reviewList", reviewList);
        model.addAttribute("category", category);
        model.addAttribute("value", value);
        return "review/adminReviewList";
    }

	@GetMapping("/delete")
	public String deleteReview(@RequestParam("rno") int rno, RedirectAttributes redirectAttributes) {
	    reviewService.deleteReview(rno);  
	    redirectAttributes.addFlashAttribute("msg", "리뷰가 삭제되었습니다.");
	    return "redirect:/reviewAdmin/list";
	}
}
