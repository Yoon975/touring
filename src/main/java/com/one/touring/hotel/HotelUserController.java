package com.one.touring.hotel;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.one.touring.review.ReviewService;
import com.one.touring.review.ReviewVo;
import com.one.touring.user.UserVo;

@Controller
@RequestMapping("/hotelUser")
public class HotelUserController {
	@Autowired
	HotelService hotelService;

	@Autowired
	ReviewService reviewService;
	
	@Autowired
	HotelUploadFileService uploadFileService;

	//좋아요
	@PostMapping("/toggleLike")
	public String toggleLike(@RequestParam int hno, HttpSession session, RedirectAttributes rttr) {
		UserVo loginUser = (UserVo) session.getAttribute("loginSession");
		if (loginUser == null) {
			rttr.addFlashAttribute("msg", "로그인이 필요한 서비스입니다.");
			return "redirect:/user/login";
		}
		int uno = loginUser.getUno();
		boolean liked = hotelService.isLiked(uno, hno);
		if (liked) {
           hotelService.cancelLike(uno, hno);  // 좋아요 취소
		} else {
    	   hotelService.addLike(uno, hno);     // 좋아요 등록
       }
		return "redirect:/hotelUser/detailHotelUser?hno=" + hno;
	}
	
	// user 디테일
	@GetMapping("/detailHotelUser")
	public ModelAndView detailHotelUser(@RequestParam("hno") int hno, HttpSession session, Model model) {	
		System.out.println("detailHotelUser()");
		HotelVo hotelVo=hotelService.detailHotel(hno);
		List<HotelFileVo> fileList = hotelService.getFileData(hno);
	    hotelVo.setFileDataList(fileList);
	    //리뷰
	    List<ReviewVo> reviewList = reviewService.getReviewsByHotelHno(hno);
        model.addAttribute("reviewList", reviewList);
        //찜
        boolean like = false;
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        if (loginUser != null) {
            int uno = loginUser.getUno();
            like = hotelService.isLiked(uno, hno);
        }
	    ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("hotel/user/detailHotelUser");
		modelAndView.addObject("hotelVo", hotelVo);
		modelAndView.addObject("like", like);
		return modelAndView;
	}

    // 호텔 리스트 + 검색 + 필터
	@GetMapping("/selectListUser")
	public ModelAndView selectListHotelUser(
	        @RequestParam(value = "hname", required = false) String hname,
	        @RequestParam(value = "hcno", required = false) String hcno,
	        @RequestParam(value = "hregion", required = false) String hregion,
	        @RequestParam(value = "minPrice", required = false) String minPrice,
	        @RequestParam(value = "maxPrice", required = false) String maxPrice,
	        @RequestParam(value = "checkin", required = false) String checkin,
	        @RequestParam(value = "checkout", required = false) String checkout) {

	    Integer minPriceInt = null;
	    Integer maxPriceInt = null;
	    Integer hcnoInt = null;

	    try {
	        if (minPrice != null && !minPrice.isEmpty()) minPriceInt = Integer.parseInt(minPrice.trim());
	        if (maxPrice != null && !maxPrice.isEmpty()) maxPriceInt = Integer.parseInt(maxPrice.trim());
	        if (hcno != null && !hcno.isEmpty()) hcnoInt = Integer.parseInt(hcno.trim());
	    } catch (NumberFormatException e) {
	        e.printStackTrace();
	    }

	    List<HotelVo> hotelList;
	    if ((hname != null && !hname.trim().isEmpty()) || hcnoInt != null ||
	        minPriceInt != null || maxPriceInt != null ||
	    	(hregion != null && !hregion.isEmpty()) ||
	        (checkin != null && !checkin.isEmpty() && checkout != null && !checkout.isEmpty())) {
	        hotelList = hotelService.searchHotelOk(hname, hcnoInt, hregion, minPriceInt, maxPriceInt, checkin, checkout);
	    } else {
	        hotelList = hotelService.selectListHotel();
	    }

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("hotel/user/selectListUser");
	    modelAndView.addObject("hotelList", hotelList);
	    modelAndView.addObject("hname", hname);
	    modelAndView.addObject("hcno", hcnoInt);
	    modelAndView.addObject("hregion", hregion);
	    modelAndView.addObject("minPrice", minPrice);
	    modelAndView.addObject("maxPrice", maxPrice);
	    modelAndView.addObject("checkin", checkin);
	    modelAndView.addObject("checkout", checkout);
	    modelAndView.addObject("selectedTcno", hcnoInt);
	    modelAndView.addObject("selectedHregion", hregion);
	    return modelAndView;
	}
	
	@GetMapping({"", "/"})
	public String defaultHotelList() {
	    return "redirect:/hotelUser/selectListUser";
	}
	

}
