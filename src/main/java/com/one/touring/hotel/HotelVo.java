package com.one.touring.hotel;

import java.util.List;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class HotelVo {
	private int hno;
	private String hname;
	private String hdescription;
	private String haddress;
	private String hprice;
	private String hreserveOk;
	private int hmax;
	private int hlike;
	private String hregdate;
	private int hcno;
	private String hregion;
	
	private List<HotelFileVo> fileDataList;
	
	private String mainFile;  // selectList에서 대표 사진용

	public String getMainFile() { return mainFile; }
	public void setMainFile(String mainFile) { this.mainFile = mainFile; }

}
