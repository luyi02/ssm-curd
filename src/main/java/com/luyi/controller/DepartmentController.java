package com.luyi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.luyi.bean.Department;
import com.luyi.bean.Msg;
import com.luyi.service.DepartmentService;

/**
 * 处理和部门有关的请求
 * @author luyi
 *
 */

@Controller
public class DepartmentController {
	
	@Autowired
	private DepartmentService departmentService;
	
	@RequestMapping("/depts")
	@ResponseBody
	public Msg getDepts(){
		List<Department> list =  departmentService.getDepts();
		return Msg.success().add("depts", list);
	    
	}
}
