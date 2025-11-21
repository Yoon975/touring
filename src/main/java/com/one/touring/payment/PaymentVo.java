package com.one.touring.payment;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class PaymentVo {
    private int pno;           // 결제번호
    private int uno;           // 회원번호
    private int hno;           // 숙소번호
    private String method;     // 결제수단
    private int hprice;        // 결제금액
    private String regdate;    // 결제날짜
	private String status;     // 결제상태 (결제완료,결제중)
	private String checkin;
	private String checkout;

	private String hname;
	
	public String getCheckin() { return checkin; }
	public void setCheckin(String checkin) { this.checkin = checkin; }
	public String getCheckout() { return checkout; }
	public void setCheckout(String checkout) { this.checkout = checkout; }
	
}
