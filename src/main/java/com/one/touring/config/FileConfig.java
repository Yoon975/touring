package com.one.touring.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

@Configuration
public class FileConfig {

	@Value("#{infoProperty['file.size']}")
	private long fileSize;
	
	@Value("#{infoProperty['file.encoding']}")
	private String fileEncoding;
	
	@Bean
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver multipartResolver=	new CommonsMultipartResolver();
		multipartResolver.setMaxUploadSize(fileSize);
		multipartResolver.setDefaultEncoding(fileEncoding);
		return multipartResolver;	
	}
}





