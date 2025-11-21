package com.one.touring.payment;

import java.sql.PreparedStatement;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

@Repository
public class PaymentDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // 결제 등록
    public void insertPayment(PaymentVo paymentVo) {
        String sql = "insert into payment (uno, hno, method, hprice, checkin, checkout, regdate, status) " +
                     "values (?, ?, ?, ?, ?, ?, NOW(), ?)";
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement preparedStatement = connection.prepareStatement(sql, new String[] {"pno"});
            preparedStatement.setInt(1, paymentVo.getUno());
            preparedStatement.setInt(2, paymentVo.getHno());
            preparedStatement.setString(3, paymentVo.getMethod());
            preparedStatement.setInt(4, paymentVo.getHprice());
            preparedStatement.setString(5, paymentVo.getCheckin());
            preparedStatement.setString(6, paymentVo.getCheckout());
            preparedStatement.setString(7, paymentVo.getStatus());
            return preparedStatement;
        }, keyHolder);

        // 생성된 결제번호
        paymentVo.setPno(keyHolder.getKey().intValue());

        // 호텔 이름
        String sqlHotel = "select hname from hotel where hno = ?";
        String hname = jdbcTemplate.queryForObject(sqlHotel, String.class, paymentVo.getHno());
        paymentVo.setHname(hname);
    }

    // 결제 상세 조회
    public PaymentVo paymentDetail(int pno) {
        String sql = "select p.*, h.hname from payment p JOIN hotel h ON p.hno = h.hno where p.pno = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(PaymentVo.class), pno);
    }
    
    // 결제 조회
    public PaymentVo getPayment(int pno) {
        String sql = "select * FROM payment where pno = ?";
        return jdbcTemplate.queryForObject(sql, new BeanPropertyRowMapper<>(PaymentVo.class), pno);
    }
}
