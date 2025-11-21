package com.one.touring.payment;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PaymentService {

    @Autowired
    private PaymentDao paymentDao;
    
    public void insertPayment(PaymentVo vo) {
        paymentDao.insertPayment(vo);
    }

    public PaymentVo paymentDetail(int pno) {
        return paymentDao.paymentDetail(pno);
    }
    
    public PaymentVo getPayment(int pno) {
        return paymentDao.getPayment(pno);
    }
}
