package com.one.touring.payment;

import com.one.touring.reserve.user.ReserveService;
import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/payment")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @Autowired
    private ReserveService reserveService;
    
    @GetMapping("/detail")
    public String paymentDetail(@RequestParam("pno") int pno, Model model) {
        PaymentVo payment = paymentService.paymentDetail(pno);
        model.addAttribute("payment", payment);
        return "payment/paymentDetail";
    }
    
    // 결제 등록
    @GetMapping("/insert")
    public String paymentInsertForm(@RequestParam("hno") int hno,
                                    @RequestParam("hprice") int hprice,
                                    @RequestParam("checkin") String checkin,
                                    @RequestParam("checkout") String checkout,
                                    Model model) {
    	
        boolean available = reserveService.isHotelAvailable(hno, checkin, checkout);
        if (!available) {
            model.addAttribute("msg", "해당 날짜에 예약 가능한 방이 없습니다.");
            model.addAttribute("url", "/reserve/insertForm?hno=" + hno);
            return "alert";
        }
        
        String hname = reserveService.detailHotel(hno).getHname();
    	
        model.addAttribute("hno", hno);
        model.addAttribute("hname", hname);
        model.addAttribute("hprice", hprice);
        model.addAttribute("checkin", checkin);
        model.addAttribute("checkout", checkout);
        return "payment/paymentInsert";
    }

    // 결제 처리 + 예약 등록
    @PostMapping("/insertOk")
    public String paymentInsertOk(PaymentVo paymentVo,
                                  HttpSession session,
                                  Model model) {
        UserVo loginUser = (UserVo) session.getAttribute("loginSession");
        paymentVo.setUno(loginUser.getUno());

        try {
            // 호텔 남은 방 체크
            boolean available = reserveService.isHotelAvailable(
                    paymentVo.getHno(),
                    paymentVo.getCheckin(),
                    paymentVo.getCheckout());
            
            if (!available) {
                model.addAttribute("msg", "해당 날짜에 예약 가능한 방이 없습니다.");
                model.addAttribute("url", "/reserve/insertForm?hno=" + paymentVo.getHno());
                return "alert";
            }

            paymentService.insertPayment(paymentVo);
            ReserveVo reserveVo = new ReserveVo();
            reserveVo.setUno(loginUser.getUno());
            reserveVo.setHno(paymentVo.getHno());
            reserveVo.setPno(paymentVo.getPno());
            reserveVo.setCheckin(paymentVo.getCheckin());
            reserveVo.setCheckout(paymentVo.getCheckout());
            reserveVo.setDprice(String.valueOf(paymentVo.getHprice()));
            reserveService.insertReserve(reserveVo);
            
            model.addAttribute("msg", "결제 및 예약이 완료되었습니다.");
            model.addAttribute("url", "/payment/detail?pno=" + paymentVo.getPno());
            model.addAttribute("payment", paymentVo);
            return "alert";
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("msg", "결제 처리 중 오류가 발생했습니다.");
            model.addAttribute("url", "/hotelUser/detailHotelUser?hno=" + paymentVo.getHno());
            return "alert";
        }
    }
}
