package com.one.touring.tour;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/tourUser")
public class TourUserController {
	@Autowired
	TourService tourService;

	@Autowired
	TourUploadFileService uploadFileService;
	
	// tour user 디테일
	@GetMapping("/detailTourUser")
	public ModelAndView detailTourUser(@RequestParam("tno") int tno) {	
		System.out.println("detailTourUser()");
		TourVo tourVo=tourService.detailTour(tno,true);		//true : 조회수 증가 O
		List<TourFileVo> fileList = tourService.getFileData(tno);
	    tourVo.setFileDataList(fileList);
	    ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("tour/user/detailTourUser");
		modelAndView.addObject("tourVo", tourVo);
		return modelAndView;
	}
	
	// tour user 리스트 // 키워드 + 카테고리 복합 검색
	@GetMapping("/selectListUser")
	public ModelAndView selectListTourUser(
	        @RequestParam(value="tcno", required=false) Integer tcno,
	        @RequestParam(value="tregion", required=false) String tregion,
	        @RequestParam(value="keyword", required=false) String keyword) {

	    System.out.println("selectListUser - tcno: " + tcno + ", tregion: " + tregion + ", keyword: " + keyword);
	    List<TourVo> tourList;

	    if (tcno != null || (keyword != null && !keyword.trim().isEmpty()) || (tregion != null && !tregion.isEmpty())) {
	        tourList = tourService.searchTour(tcno, tregion, keyword);
	    } else {
	        tourList = tourService.selectListTour();
	    }

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("tour/user/selectListUser");
	    modelAndView.addObject("tourList", tourList);
	    modelAndView.addObject("selectedTcno", tcno);
	    modelAndView.addObject("selectedTregion", tregion);
	    modelAndView.addObject("keyword", keyword);
	    return modelAndView;
	}
	
//	// user 리스트
//	@GetMapping("/selectListUser")
//	public ModelAndView selectListTourUser() {
//		System.out.println("selectListUser()");
//		List<TourVo> tourList=tourService.selectListTour();
//		ModelAndView modelAndView=new ModelAndView();
//		modelAndView.setViewName("tour/user/selectListUser");
//		modelAndView.addObject("tourList",tourList);
//		return modelAndView;
//	}	
	
	@GetMapping({"", "/"})
	public String defaultTourList() {
	    return "redirect:/tourUser/selectListUser";
	}
}
