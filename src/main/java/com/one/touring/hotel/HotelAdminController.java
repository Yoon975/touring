package com.one.touring.hotel;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import com.one.touring.review.ReviewService;
import com.one.touring.review.ReviewVo;

@Controller
@RequestMapping("/hotelAdmin")
public class HotelAdminController {
	@Autowired
	HotelService hotelService;

	@Autowired
	ReviewService reviewService;
	
	@Autowired
	HotelUploadFileService uploadFileService;
	
	@GetMapping("/checkReservations")
	@ResponseBody
	public Map<String, Object> checkReservations(@RequestParam("hno") int hno) {
	    boolean hasFutureReservations = hotelService.hasFutureReservations(hno);
	    Map<String, Object> result = new HashMap<>();
	    result.put("hasFutureReservations", hasFutureReservations);
	    return result;
	}
	
	// hotel 삭제
	@GetMapping("/deleteHotel")
	public String deleteHotel(@RequestParam("hno") int hno) {
	    System.out.println("deleteHotel()");
	    // 예약 내역 -> 사진 삭제
	    hotelService.deleteHotel(hno);   
	    return "redirect:/hotelAdmin/selectListAdmin";
	}
	
	// hotel 수정
	@GetMapping("/updateHotel")
	public String updateHotel(@RequestParam("hno") int hno, Model model) {
		System.out.println("Hotelcontroller updateHotel()");
		HotelVo hotelVo=hotelService.detailHotel(hno);		//false : 조회수 증가 X
		model.addAttribute("hotelVo", hotelVo);
		return "hotel/admin/updateHotelAdmin";
	}
	
	// hotel 수정 Ok
	@PostMapping("/updateHotelOk")
	public String updateHotelOk(HotelVo hotelVo, @RequestParam("multi") List<MultipartFile> multiList,@RequestParam(value="deleteFiles", required=false) List<Integer> deleteFiles) {
		System.out.println("Hotelcontroller updateHotelOk()");
		// 1. 체크된 파일 삭제
	    if(deleteFiles != null) {
	        for(Integer hfno : deleteFiles) {
	            hotelService.fileRemove(hfno);
	        }
	    }
	    // 2. 새로 업로드된 파일 처리
	    List<HotelFileVo> fileDataList = null;
	    boolean fileUp = false;
	    if(!multiList.get(0).getOriginalFilename().equals("")) {
	        fileDataList = uploadFileService.upload(multiList, hotelVo.getHno());
	        fileUp = true;
	    }
	    // 3. 호텔 정보 업데이트
	    hotelService.updateHotel(hotelVo, fileDataList, fileUp);
	    return "redirect:/hotelAdmin/detailHotelAdmin?hno="+hotelVo.getHno();
	}

	// hotel 파일 삭제
	@GetMapping("/fileRemove")
	public String fileRemove(@RequestParam("hfno") int hfno, @RequestParam("hno") int hno) {
	    System.out.println("HotelController fileRemove()");
	    // 파일 삭제 (DB + 서버 저장 파일 삭제)	
	    hotelService.fileRemove(hfno);
	    // 다시 수정 페이지로 리다이렉트
	    return "redirect:/hotelAdmin/updateHotel?hno=" + hno;
	}
	
	// hotel 등록
	@GetMapping("/insertHotel")
    public String insertHotel() {
		System.out.println("HotelController insertHotel()");
        return "hotel/admin/insertHotelAdmin";
    }
	
	// hotel 등록 Ok
    @PostMapping("/insertHotelOk")
    public String insertHotelOk(HotelVo hotelVo, @RequestParam("multi") List<MultipartFile> multi) {
		System.out.println("HotelController insertHotelOk()");
        int hno = hotelService.insertHotel(hotelVo);
        if (multi != null && !multi.isEmpty()) {
            List<HotelFileVo> fileList = uploadFileService.upload(multi, hno);
            hotelService.insertHotelFiles(fileList);
        }
        return "redirect:/hotelAdmin/selectListAdmin";
    }
    
	// hotel 디테일
	@GetMapping("/detailHotelAdmin")
	public ModelAndView detailHotelAdmin(@RequestParam("hno") int hno, Model model) {	
		System.out.println("HotelController detailHotelAdmin()");
		HotelVo hotelVo=hotelService.detailHotel(hno);
		List<HotelFileVo> fileList = hotelService.getFileData(hno);
	    hotelVo.setFileDataList(fileList);
	    List<ReviewVo> reviewList = reviewService.getReviewsByHotelHno(hno);
        model.addAttribute("reviewList", reviewList);
	    ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("hotel/admin/detailHotelAdmin");
		modelAndView.addObject("hotelVo", hotelVo);
		return modelAndView;
	}

    // 호텔 리스트 + 검색 + 필터
	@GetMapping("/selectListAdmin")
	public ModelAndView selectListHotelAdmin(
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
	    modelAndView.setViewName("hotel/admin/selectListAdmin");
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
	
//	// hotel 리스트
//	@GetMapping("/selectListAdmin")
//	public ModelAndView selectListHotelAdmin() {
//		System.out.println("HotelController selectListAdmin()");
//		List<HotelVo> hotelList=hotelService.selectListHotel();
//		ModelAndView modelAndView=new ModelAndView();
//		modelAndView.setViewName("hotel/admin/selectListAdmin");
//		modelAndView.addObject("hotelList",hotelList);
//		return modelAndView;
//	}	
	
	// hotel 기본값
	@GetMapping({"", "/"})
	public String defaultHotelList() {
	    return "redirect:/hotelAdmin/selectListAdmin";
	}
	

}
