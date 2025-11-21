package com.one.touring.user;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.one.touring.hotel.HotelVo;

@Service
public class UserService {
	@Autowired
	UserDao userDao;
	
	//좋아요 목록 조회
    public List<HotelVo> getLikedHotels(int uno) {
        return userDao.getLikedHotels(uno);
    }
    
	public UserVo loginOk(String id, String pw) {
		return userDao.loginOk(id,pw);
	}
	public int insert(UserVo vo) {
		return userDao.insert(vo);
	}
	public List<UserVo> selectAll(){
		return userDao.selectAll();
	}
	public UserVo select_uno(int uno) {
		return userDao.select_uno(uno);
	}
	public int update(UserVo vo) {
		return userDao.update(vo);
	}
	public int delete(int uno) {
		return userDao.delete(uno);
	}
	public boolean idCk(String id) {
		return userDao.idCk(id);
	}
	public void adminTry(int uno) {
		userDao.adminTry(uno);
	}
	public void adminTryOk(int uno) {
		userDao.adminTryOk(uno);
	}
	public void adminTryNo(int uno) {
		userDao.adminTryNo(uno);
	}
	public boolean pwCheck(String id,String pw) {
		return userDao.pwCheck(id, pw);
	}
	public void updatePw(String id, String pw) {
		userDao.updatePw(id, pw);
	}
}
