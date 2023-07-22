global class HttpMockFactory implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String body;
    protected Map<String,String> responseheader;
    global HttpMockFactory(Integer code, String status, String body, Map<String,String> responseheader){
        this.code = code;
        this.status = status;
        this.body = body;
        this.responseheader = responseheader;
    }
    global HTTPResponse respond(HttpRequest req){
        HttpResponse resp=new HttpResponse();
        for(String key:this.responseheader.keySet()){
            resp.setHeader(key,this.responseheader.get(key));
        }
        resp.setStatus(this.status);
        resp.setBody(this.body);
        resp.setStatusCode(this.code);
        return resp;
        
    }
    
}