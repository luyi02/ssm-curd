package com.luyi.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.luyi.bean.Employee;
import com.luyi.bean.Msg;
import com.luyi.service.EmployeeService;

@Controller
public class EmployeeController {
	
	@Autowired
	private EmployeeService employeeService;
	
	/**
	 * 获取所有员工的数据并返回json格式的数据
	 * @param pn
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getEmpl")
	public Msg getEmpsWithJson(
			@RequestParam(value="pn", defaultValue="1") Integer pn){
		
		//分页操作放在要进行查询的语句之前，然后第一个参数为页码，第二个参数为一页多少行
		PageHelper.startPage(pn, 5);
		List<Employee> employeeList =  employeeService.getAll();
		
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据
		PageInfo pageInfo = new PageInfo(employeeList, 5);
		return Msg.success().add("pageInfo", pageInfo);
		
	}
	
	/**
	 * 获取所有员工
	 * @param pn
	 * @param model
	 * @return
	 */
	@RequestMapping("/getAll")
	public String getAll(@RequestParam(value="pn", defaultValue="1") Integer pn, Model model){
		
		//分页操作放在要进行查询的语句之前，然后第一个参数为页码，第二个参数为一页多少行
		PageHelper.startPage(pn, 5);
		List<Employee> employeeList =  employeeService.getAll();
		
		//使用pageInfo包装查询后的结果，只需要将pageInfo交给页面就行了
		//封装了详细的分页信息，包括有我们查询出来的数据
		PageInfo pageInfo = new PageInfo(employeeList, 5);
		model.addAttribute("pageInfo", pageInfo);
		return "list";
	}
	
	/**
	 * 员工保存
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/empl", method=RequestMethod.POST)
	//告诉说要进行校验
	public Msg saveEmpl(@Valid Employee employee, BindingResult result){
		if(result.hasErrors()){
			//校验失败，应该返回失败，在模态框中显示校验失败的错误信息 
			Map<String, Object> map = new HashMap<String, Object>();
			List<FieldError> errors = result.getFieldErrors();
			for(FieldError fieldError:errors){
				System.out.println("错误的字段名" + fieldError.getField());
				System.out.println("错误信息：" + fieldError.getDefaultMessage());
				map.put(fieldError.getField(), fieldError.getDefaultMessage());
			}
			return Msg.fail().add("errorFields", map);
		}else{
			employeeService.saveEmpl(employee);
			return Msg.success();
		}
	}
	
	/**
	 * 检查姓名是否可用
	 * @param empName
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/checkuser")
	public Msg checkuser(@RequestParam("empName")String empName){
		
		//先判断姓名是否是合法的表达式
		String regx = "(^[A-Za-z0-9]{6,16}$)|(^[\u4e00-\u9fa5]{2,6}$)";
		
		if(!empName.matches(regx)){
			return Msg.fail().add("va_msg", "姓名只能是6-16位英文字母和数字或者2-6位的中文组成（后端校验）");	
		}
		//数据库姓名重复校验
		boolean b = employeeService.checkUser(empName);
		if(b){
			return Msg.success();
		}else{
			return Msg.fail().add("va_msg", "该员工姓名不可用");
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/empl/{nid}", method=RequestMethod.GET)
	public Msg getEmpl(@PathVariable("nid")Integer nid){
		Employee employee = employeeService.getEmpl(nid);
		return Msg.success().add("emp", employee);
	}
	
	
	/**
	 * Ajax发送put请求时，自动封装的employee对象除了nid之外，
	 * 其他数据都没封装上，但是在请求体中是有这些数据，
	 * 这样就会导致sql语句的错误：update employee [没东西，所以报错] where nid = nid;
	 * 
	 * 原因：tomcat将请求体重的数据，封装成一个map，request.getParamter("name")
	 * 就会从这个map中取值，SpringMVC封装POJO对象的时候，会把POJO中每个属性的值，用request.getParamter("name")得到的值赋值
	 * 
	 * 
	 * AJAX发送PUT请求时，请求体中的数据，request.getParameter("name")是拿不到的，
	 * tomcat一看是PUT请求就不会封装请求中的数据为map，它只会封装POST请求里的请求体的数据
	 */
	/**
	 * 解决方案：
	 * 我们要能支持直接发送PUT之类的请求还要封装请求体中的数据，
	 * 就需要配置HttpPutFormContentFilter,
	 * 他的作用就是将请求体中的数据解析包装成一个map，
	 * request被重新包装，request.getParamter()被重写，
	 * 就会从自己封装的map中取数据
	 */
	/**
	 * 员工更新方法
	 * @param nid
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/empl/{nid}", method=RequestMethod.PUT)
	public Msg updateEmpl(Employee employee){
		System.out.println(employee);
		employeeService.updateEmpl(employee);
		return Msg.success();
	}
	
	/**
	 * 单个删除和批量删除二为一
	 * 1-2-3
	 * @param nids
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/empl/{nids}", method=RequestMethod.DELETE)
	public Msg deleteEmpl(@PathVariable("nids")String nids){
		if(nids.contains("-")){
			List<Integer> del_nids = new ArrayList<Integer>();
			String[] str_nids = nids.split("-");
			
			//组装id的集合
			for(String s:str_nids){
				del_nids.add(Integer.parseInt(s));
			}
			
			employeeService.deleteBatch(del_nids);
		}else{
			Integer nid = Integer.parseInt(nids);
			employeeService.deleteEmpl(nid);
		}
		return Msg.success();
	}
}
