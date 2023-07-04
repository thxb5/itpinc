function gfn_isNull(str) {
	if (str == null) return true;
	if (str == "NaN") return true;
	if (new String(str).valueOf() == "undefined") return true;    
    var chkStr = new String(str);
    if( chkStr.valueOf() == "undefined" ) return true;
    if (chkStr == null) return true;    
    if (chkStr.toString().length == 0 ) return true;   
    return false; 
}

function ComSubmit(opt_formId)  //-> �Է��� �����̵�
{
	this.formId = gfn_isNull(opt_formId) == true ? "commonForm" : opt_formId;
	this.url = "";
	
	if(this.formId == "commonForm"){
		$("#commonForm")[0].reset();
	}
	
	this.setUrl = function setUrl(url){
		this.url = url;
	};
	
	this.addParam = function addParam(key, value)
	{
		$("#"+this.formId).append($("<input type='hidden' name='"+key+"'id='"+key+"' value='"+value+"'>"));
	};
	
	this.submit = function submit()
	{
		var frm = $("#"+this.formId)[0];
		frm.action = this.url;
		frm.method = "post";
		frm.submit();	
	};
}

 var gfv_ajaxCallback = "";
 
 function ComAjax(opt_formId)
 {
	 this.url = "";
	 this.formId = gfn_isNull(opt_formId) == true?"commonForm":opt_formId;
	 this.param = "";
	 
	 if(this.formId == "commonForm")
	 {
		 var frm = $("#commonForm");
		 if(frm.length>0){
			 frm.remove();
		 }
		 
		 var str = "<form id='commonForm' name='commonForm'></form>";
		 $('body').append(str);
	 }
	 
	 this.setUrl = function setUrl(url)
	 {
		 this.url = url;
	 };
	 
	 this.setCallback = function setCallback(callBack)
	 {
		 fv_ajaxCallback = callBack;
	 };
	 
	 this.addParam = function addParam(key, value)
	 {
		 this.param = this.param + "&" + key + "=" + value;
	 };
	 
	 this.ajax = function ajax()
	 {
		 if(this.formId != "commonForm"){
			 this.param += "&" + $("#" + this.formId).serialize();
		 }
		 $.ajax({
			 url : this.url,
			 type : "post",
			 data : this.param,
			 async : false,
			 success : function(data, status){
				 if(typeof(fv_ajaxCallback) == "function"){
					 fv_ajaxCallback(data);
				 }else{
					 eval(fv_ajaxCallback + "(data);");
				 }
			 }
		 });	 
	 };
 }
 
 //����¡ �±׺κ�
 /*
  * divId : ����¡ �±װ� �׷��� div
  * pageIndx : ���� ������ ��ġ�� ����� input �±� id
  * recordCount : �������� ���ڵ� ��
  * totalCount : ��ü ��ȸ �Ǽ�
  * eventName : ����¡ �ϴ��� ���� ���� ��ư�� Ŭ���Ǿ����� ȣ��� �Լ� �̸�
  */
 
 var gfv_pageIndex = null;
 var gfv_eventName = null;
 
 function gfn_renderPaging(params)
 {
	 var divId = params.divId; //����¡�� �׷��� div id
	 gfv_pageIndex = params.pageIndex; //���� ��ġ�� ����� input �±�
	 var totalCount = params.totalCount; //��ü ��ȸ �Ǽ�
	 var currentIndex = $("#"+params.pageIndex).val(); //���� ��ġ
	 if($("#"+params.pageIndex).length == 0 || gfn_isNull(currentIndex) == true){
		 currentIndex = 1;
	 }
	 
	 var recordCount = params.recordCount; //�������� ���ڵ� ��
	 if(gfn_isNull(recordCount) == true){
		 recordCount = 20;
	 }
	 
	 var totalIndexCount = Math.ceil(totalCount/recordCount); //��ü �ε��� ��
	 gfn_eventName = params.eventName;
	 /*
	  * Math.floor : �Ҽ��� ����
	  * Math.ceil : �Ҽ��� �ø�
	  * Math.round : �ݿø�
	  * Math.random : �����Լ�
	  * Math.sqrt : ������
	  * Math.pow : ����
	  * Math.abs : ���밪
	  */
	 
	 $("#"+divId).empty();
	 var preStr = "";
	 var postStr = "";
	 var str = "";
	 
	 var first = (parseInt((currentIndex-1)/10)*10) + 1;
	 var last = (parseInt(totalCount/10)==parseInt(currentIndex/10))?totalIndexCount%10:10;
	 var prev = (parseInt((currentIndex-1)/10)*10) - 9 > 0 ? (parseInt((currentIndex-1)/10)*10) - 9 : 1; 
	 var next = (parseInt((currentIndex-1)/10)+1) * 10 + 1 < totalIndexCount ? (parseInt((currentIndex-1)/10)+1) * 10 + 1 : totalIndexCount;

	 if(totalIndexCount>10){
		 preStr += "<a href='#this' class='pad_5' onclick='_movePage(1)'>[<<]</a>"
	 }
	 
	 
 }