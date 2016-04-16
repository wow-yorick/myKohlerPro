package com.kohler.service;

import java.util.List;
import java.util.Map;

import com.kohler.dao.utils.Pager;
import com.kohler.entity.TemplateEntity;
/**
 * 
 * @author ys
 *	
 */
public interface TemplateService {
	public Pager<Map<String, Object>> getAllTemplate(Pager<Map<String, Object>> pager,TemplateEntity template);
	public TemplateEntity createTemplate(TemplateEntity template);
	public int deleteTemplte(TemplateEntity tmplate);
	public int updateTemplte(TemplateEntity template);
	public List<Map<String, Object>> getAllType(List<Object> template);
	public List<Map<String, Object>> getAllFolder(List<Object> template);
	public List<Map<String, Object>> selectOne(List<Object> template);
	public List<Map<String, Object>> selecForName(List<Object> template);
}
