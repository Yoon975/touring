package com.one.touring.reserve.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.one.touring.reserve.user.ReserveVo;
import com.one.touring.user.UserVo;

@Service
public class ReserveAdminService {

    @Autowired
    private ReserveAdminDao reserveAdminDao;

    
    public List<ReserveVo> getAllReserves() {
        return reserveAdminDao.getAllReserves();
    }

    
    public List<ReserveVo> getReserveByDno(int dno) {
        return reserveAdminDao.getReserveByDno(dno);
    }

    
    public List<ReserveVo> getReserveByHno(int hno) {
        return reserveAdminDao.getReserveByHno(hno);
    }

    
    public List<ReserveVo> getReserveByUno(int uno) {
        return reserveAdminDao.getReserveByUno(uno);
    }
    
	public UserVo getUserByUno(int uno) {
		return reserveAdminDao.getNameByUno(uno);
	}

	 public List<ReserveVo> getReservesByUname(String name) {
	        return reserveAdminDao.getReserveByUnameLike(name);
	    }
}