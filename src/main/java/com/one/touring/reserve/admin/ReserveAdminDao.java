package com.one.touring.reserve.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;

@Repository
public class ReserveAdminDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    /**
     * 전체 예약 목록 조회
     */
    public List<ReserveVo> getAllReserves() {
        String sql =
            "SELECT d.dno, d.uno, d.hno, d.pno, d.checkin, d.checkout, d.dprice, " +
            "       h.hname AS hotelName, u.name AS name " +
            "FROM deal d " +
            "JOIN hotel h ON d.hno = h.hno " +
            "JOIN user u ON d.uno = u.uno " +
            "ORDER BY d.dno DESC";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReserveVo.class));
    }

    /**
     * 거래번호(dno)로 예약 상세 조회
     */
    public List<ReserveVo> getReserveByDno(int dno) {
        String sql =
            "SELECT d.dno, d.uno, d.hno, d.pno, d.checkin, d.checkout, d.dprice, " +
            "       h.hname AS hotelName, u.name AS name " +
            "FROM deal d " +
            "JOIN hotel h ON d.hno = h.hno " +
            "JOIN user u ON d.uno = u.uno " +
            "WHERE d.dno = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReserveVo.class), dno);
    }

    /**
     * 호텔번호(hno)로 예약 목록 조회
     */
    public List<ReserveVo> getReserveByHno(int hno) {
        String sql =
            "SELECT d.dno, d.uno, d.hno, d.checkin, d.checkout, d.dprice, " +
            "       h.hname AS hotelName, u.name AS name " +
            "FROM deal d " +
            "JOIN hotel h ON d.hno = h.hno " +
            "JOIN user u ON d.uno = u.uno " +
            "WHERE d.hno = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReserveVo.class), hno);
    }

    /**
     * 회원번호(uno)로 예약 목록 조회
     */
    public List<ReserveVo> getReserveByUno(int uno) {
        String sql =
            "SELECT d.dno, d.uno, d.hno, d.pno, d.checkin, d.checkout, d.dprice, " +
            "       h.hname AS hotelName, u.name AS name " +
            "FROM deal d " +
            "JOIN hotel h ON d.hno = h.hno " +
            "JOIN user u ON d.uno = u.uno " +
            "WHERE d.uno = ?";
        return jdbcTemplate.query(sql, new BeanPropertyRowMapper<>(ReserveVo.class), uno);
    }

    /**
     * 회원번호(uno)로 회원 기본정보 조회
     */
    public UserVo getNameByUno(int uno) {
        String sql = "SELECT uno, name, email, phone FROM user WHERE uno = ?";
        return jdbcTemplate.queryForObject(
            sql,
            new BeanPropertyRowMapper<>(UserVo.class),
            uno
        );
    }

    /**
     * 회원 이름(name)으로 예약 목록 조회
     */
    public List<ReserveVo> getReserveByUnameLike(String name) {
        // 1. 이름이 포함된 회원의 uno 목록 조회
        String userSql = "SELECT uno FROM user WHERE name LIKE ?";
        String keyword = "%" + name + "%"; // 부분 검색용 키워드
        List<Integer> unoList = jdbcTemplate.queryForList(userSql, Integer.class, keyword);

        // 2. 해당 이름을 가진 회원이 없으면 빈 리스트 반환
        if (unoList.isEmpty()) {
            return List.of();
        }

        // 3. 여러 명이 있을 수 있으므로 IN 절로 예약 조회
        String reserveSql =
            "SELECT d.dno, d.uno, d.hno, d.checkin, d.checkout, d.dprice, " +
            "       h.hname AS hotelName, u.name AS name " +
            "FROM deal d " +
            "JOIN hotel h ON d.hno = h.hno " +
            "JOIN user u ON d.uno = u.uno " +
            "WHERE d.uno IN (" + makePlaceholders(unoList.size()) + ") " +
            "ORDER BY d.dno DESC";

        // JdbcTemplate은 가변 개수 파라미터를 Object 배열로 넘겨야 함
        return jdbcTemplate.query(
            reserveSql,
            new BeanPropertyRowMapper<>(ReserveVo.class),
            unoList.toArray()
        );
    }

    /**
     * IN 절에 들어갈 ? 플레이스홀더 문자열 생성
     * 예: size=3 → "?,?,?"
     */
    private String makePlaceholders(int size) {
        return String.join(",", java.util.Collections.nCopies(size, "?"));
    }
}
