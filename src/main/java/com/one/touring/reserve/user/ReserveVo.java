package com.one.touring.reserve.user;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ReserveVo {
    private int dno;
    private int uno;
    private int hno;
    private int pno;
    private String dregdate;
    private String checkin;
    private String checkout;
    private String dprice;
    private String hotelName;
    private String name;

    public String getDisplayDno() {
        return uno + "HRN" + hno+dregdate+dno;
    }
    
    private boolean hasReview;        // 由щ럭 �옉�꽦 �뿬遺�
    
    private boolean canWriteReview;    // 由щ럭 �옉�꽦 媛��뒫 �뿬遺�
    
    private boolean canUse;    // �샇�뀛 �씠�슜 �쟾 �뿬遺�
}
