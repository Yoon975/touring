package com.one.touring.tour;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/tourAdmin")
public class TourAdminController {
	@Autowired
	TourService tourService;

	@Autowired
	TourUploadFileService uploadFileService;

	// tour 삭제
	@GetMapping("/deleteTour")
	   public String deleteTour(@RequestParam("tno") int tno) {
	      System.out.println("deleteTour()");
	      tourService.deleteTour(tno);   
	      return "redirect:/tourAdmin/selectListAdmin";
	   }
	
	// tour 수정
	@GetMapping("/updateTour")
	public String updateTour(@RequestParam("tno") int tno, Model model) {
		System.out.println("Tourcontroller updateBoard()");
		TourVo tourVo=tourService.detailTour(tno, false);		//false : 조회수 증가 X
		model.addAttribute("tourVo", tourVo);
		return "tour/admin/updateTourAdmin";
	}
	
	// tour 수정 Ok
	@PostMapping("/updateTourOk")
	public String updateTourOk(TourVo tourVo, @RequestParam("multi") List<MultipartFile> multiList,@RequestParam(value="deleteFiles", required=false) List<Integer> deleteFiles) {
		System.out.println("Tourcontroller updateTourOk()");
		// 1. 체크된 파일 삭제
	    if(deleteFiles != null) {
	        for(Integer tfno : deleteFiles) {
	            tourService.fileRemove(tfno);
	        }
	    }
	    // 2. 새로 업로드된 파일 처리
	    List<TourFileVo> fileDataList = null;
	    boolean fileUp = false;
	    if(!multiList.get(0).getOriginalFilename().equals("")) {
	        fileDataList = uploadFileService.upload(multiList, tourVo.getTno());
	        fileUp = true;
	    }
	    // 3. 호텔 정보 업데이트
	    tourService.updateTour(tourVo, fileDataList, fileUp);
	       return "redirect:/tourAdmin/detailTourAdmin?tno=" + tourVo.getTno();
	}

	// tour 파일 삭제
	@GetMapping("/fileRemove")
	public String fileRemove(@RequestParam("tfno") int tfno, @RequestParam("tno") int tno) {
	    System.out.println("TourController fileRemove()");
	    // 파일 삭제 (DB + 서버 저장 파일 삭제)	
	    tourService.fileRemove(tfno);
	    // 다시 수정 페이지로 리다이렉트
	    return "redirect:/tourAdmin/updateTour?tno=" + tno;
	}
	
	// tour 등록
	@GetMapping("/insertTour")
    public String insertTour() {
		System.out.println("TourController insertTour()");
        return "tour/admin/insertTourAdmin";
    }
	
	// tour 등록 Ok
    @PostMapping("/insertTourOk")
    public String insertTourOk(TourVo tourVo, @RequestParam("multi") List<MultipartFile> multi) {
		System.out.println("TourController insertTourOk()");
        int tno = tourService.insertTour(tourVo);
        if (multi != null && !multi.isEmpty()) {
            List<TourFileVo> fileList = uploadFileService.upload(multi, tno);
            tourService.insertTourFiles(fileList);
        }
        return "redirect:/tourAdmin/selectListAdmin";
    }
	
	// tour 디테일
	@GetMapping("/detailTourAdmin")
	public ModelAndView detailTourAdmin(@RequestParam("tno") int tno) {	
		System.out.println("TourController detailTourAdmin()");
		TourVo tourVo=tourService.detailTour(tno,true);		//true : 조회수 증가 O
		List<TourFileVo> fileList = tourService.getFileData(tno);
	    tourVo.setFileDataList(fileList);
	    ModelAndView modelAndView=new ModelAndView();
		modelAndView.setViewName("tour/admin/detailTourAdmin");
		modelAndView.addObject("tourVo", tourVo);
		return modelAndView;
	}

	// tour admin 리스트 // 키워드 + 카테고리 복합 검색
	@GetMapping("/selectListAdmin")
	public ModelAndView selectListTourAdmin(
	        @RequestParam(value="tcno", required=false) Integer tcno,
	        @RequestParam(value="tregion", required=false) String tregion,
	        @RequestParam(value="keyword", required=false) String keyword) {

	    System.out.println("selectListAdmin - tcno: " + tcno + ", tregion: " + tregion + ", keyword " + keyword);
	    List<TourVo> tourList;

	    if (tcno != null || (keyword != null && !keyword.trim().isEmpty()) || (tregion != null && !tregion.isEmpty())) {
	        tourList = tourService.searchTour(tcno, tregion, keyword);
	    } else {
	        tourList = tourService.selectListTour();
	    }

	    ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("tour/admin/selectListAdmin");
	    modelAndView.addObject("tourList", tourList);
	    modelAndView.addObject("selectedTcno", tcno);
	    modelAndView.addObject("selectedTregion", tregion);
	    modelAndView.addObject("keyword", keyword);
	    return modelAndView;
	}
	
//	// tour 리스트
//	@GetMapping("/selectListAdmin")
//	public ModelAndView selectListTourAdmin() {
//		System.out.println("selectListAdmin()");
//		List<TourVo> tourList=tourService.selectListTour();
//		ModelAndView modelAndView=new ModelAndView();
//		modelAndView.setViewName("tour/admin/selectListAdmin");
//		modelAndView.addObject("tourList",tourList);
//		return modelAndView;
//	}
	
	// tour 기본값
	@GetMapping({"", "/"})
	public String defaultTourList() {
	    return "redirect:/tourAdmin/selectListAdmin";
	}
}
