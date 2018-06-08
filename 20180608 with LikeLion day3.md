# 20180608 Ruby With LikeLion - Day3

## **새로운 폴더에 sinatra 프로젝트 넣기**

- app.rb파일생성 후 views 폴더 생성

- sinatra 와 sinatra-reloader 잼을 설치

  *test_app/app.rb*

````ruby
require 'sinatra'
require 'sinatra-reloader'

get '/' do
    erb :app
end
````



## **Form 이용해보기**

* Form을 통해서  숫자를 받아보자

  *numbers.erb* 

````ruby
<form action="/calculate">
    첫번째 숫자:<input type="text" name="n1">
    두번째 숫자:<input type="text" name="n2">
</form>
````

* 여기서 받은 숫자는 `action`을 통해서 `/calculate`로 간다.

  *calculate*

  ````ruby
  <ul>
      <li>합: <%= @sum %></li>
      <li>차: <%= @min %></li>
      <li>곱: <%= @mul %></li>
      <li>나누기: <%= @div %></li>
  </ul>
  ````

* *app.rb*에서는 *numbers*에서 받은 값으로 계산을 한뒤, *calculate*로 넘겨준다.

  *app..rb*

  ````
  get '/form' do
     erb :form 
  end
  
  get '/numbers' do
      erb :numbers
  end
  
  get '/calculate' do
      num1 = params[:n1].to_i
      num2 = params[:n2].to_i
      @sum = num1 + num2
      @min = num1 - num2
      @mul = num1 * num2
      @div = num1 / num2
      erb :calculate
  end
  ````



## Get & Post

1. 방금 사용한 form을 통해서 아이디와 비밀번호를 받는 페이지를 만든다. 이때, 아이디와 비밀번호를 입력했을때, 이 정보를 url상에 노출된 상태로 보내면 정보가 유출문제가 있기때문에 url에 숨겨서 입력정보를 보내는 Post방식을 사용하도록한다. 

*form.erb*

````ruby
<form action = "/login" method ="POST">
    아이디: <input type ='text' name = 'id'>
    비밀번호: <input type = 'password' name = 'password'>
    <input type="submit" value="로그인">
</form>
````

* post 요청을  ruby에서 받기위해서는 

```ruby
post '/' do

end
```

- 기본적으로 POST 요청에 대한 로직은 직접 뷰를 렌더링하는 것이 아니라 다른 페이지로 redirect시킨다.
- 새로고침등을 통한 접속불가등의 현상을 막기 위한 방침
- 이후 게시판 글을 만드는 요청에 대한 로직을 구성시에도 동일한 방식으로 구성한다.

2. app.rb 에서 다음과 같이 작성한다.

   *app.rb*

   ````ruby
   #미리 정오를 확인할 아이디와 비밀번호를 입력해준다.
   id = "multi"
   pw = "campus"
   
   post '/login' do 
       # 아이디를 체크하는 로직
       if id.eql?(params[:id])
           # 비밀번호를 체크하는 로직
     
   ````

   **client -> controller -> view 의 사이클을 돌 때, 하나의 한개의 단만 사용가능하다. 즉, 다음 단계로 넘어가면 그 전의 단계는 disconnection상태가 되기때문에, 위와같이 erb파일을 return 하는 방식으로 보여준다면 refresh를 했을 때 connection이 끊겼기 때문에 다시 받아올 수가 없다. 그러므로 저 방식으로 보여주는 것이 아닌 redirect로 다시 한번 요청을 보내준다. 보통 post방식에서는 view를 그대로 가져오는 것이 아닌, redirect로 가져오는 것을 약속으로 한다.** 

   ````ruby
         	if pw.eql?(params[:password])          
               # 여기서 한번 사이클이 끊기기때문에, redirect로 다시 요청해준다.
               redirect '/complete'       
   		else
               #@msg = "비밀번호가 틀립니다." <- 이렇게 하면 아무것도 받아오지 못한다.
               redirect '/error?err_co=2' # 에러코드를 만들어주어 다시 연결할 수 있도록 한다.
           end
       else
           # ID가 존재하지 않습니다 라는 로직
           #@msg = "아이디가 존재하지 않습니다."
           redirect '/error?err_co=1'
       end
   end
   
   # 계정이 존재하지않거나, 비밀번호가 틀린경우
   get '/error' do
       # 다른 방식으로 에러 메세지를 보여주자
       if params[:err_co].to_i == 1
       # ID가 없는 경우
       @msg = "해당 ID는 존재하지 않습니다."
       elsif params[:err_co].to_i == 2
       # PW가 틀린 경우
       @msg = "비밀번호가 틀렸습니다."
       end
       erb :error
   end
   
   # 로그인 완료된 곳
   
   get '/complete' do
      erb :complete
   end
   
   get '/search' do
       erb :search
   end
   ````

   

## **검색창만들기** 

* /search 에는 검색어 입력창 두개
* 한개는 구글검색
* 한개는 네이버검색

*app.rb*

````ruby
get '/search' do
    erb :search
end

post '/search' do
    case params[:engine] # 검색 엔진이 무엇인지 확인한다.
    when "naver"
        redirect "https://search.naver.com/search.naver?query=#{params[:query]}"
    when "google"
        redirect "https://www.google.com/search?q=#{params[:q]}"
    end
end

````

*search.rb*

````html
<p>----form action을 이용한 방법----</p>
<form action="https://search.naver.com/search.naver">
    # 검색값을 받아오는 것의 이름이 query이기에 name을 query로 바꿔준다.
    <input type="text" name="query" placeholder="네이버 검색창"> 
    <input type="submit" value = "search">
</form>

<form action="https://www.google.com/search">
    <input type="text" name="q" placeholder="구글 검색창">
    <input type="submit" value = "search">
</form>

<p>----form method POST를 이용한 방법----</p>
<form method="POST">
    <!-- 여기에 입력하면 engine을 naver값으로 인식한다. -->
    <input type="hidden" name="engine" value="naver">
    <input type="text" name="query" placeholder="네이버 검색">
    <input type="submit" value="검색">
</form>

<form method="POST">
    <!-- 여기에 입력하면 engine을 google값으로 인식한다. -->
    <input type="hidden" name="engine" value="google">
    <input type="text" name="q" placeholder="구글 검색">
    <input type="submit" value="검색">
</form>
````

## Make Fake op.gg 



*op_gg.erb*

````html
<form>
    <select name ="search_method">
        <option value = "self">Win/Lose</option>
        <option value = "opgg">by op.gg</option>
    </select>
    <input type ="text" placeholder ="소환사명" name = "username">
    <input type ="submit" value ="search">
</form>

<%if params[:username]%> 
<!-- 눈에 보여야하는 건 %=, 아닌건 그냥 % -->
<!-- 이건 option value를 self였을때만 보여야하는 것이기에 숨겨준다. -->
 <ul>
    <li><%= params[:username]%>님의 최근 20전 전적입니다.</li>
    <li><%= @win%> 승</li>
    <li><%= @lose%> 패</li>
 </ul>
<%end%>
````

*app.rb*

````ruby
get '/op_gg' do
    if params[:username]
        case params[:search_method]
        #op.gg에서 승/패 수만 크롤링해서 보여준다.
        when 'self'
            # Rest client를 통해 op.gg에서 검색결과 페이지를 크롤링
            url = RestClient.get(URI.encode("http://www.op.gg/summoner/userName=#{params[:username]}"))
            # 검색결과 페이지 중에서  win과 lose 부분을 찾음
            # nokogiri를 이용해서 원하는 부분을 골라냄
            result = Nokogiri::HTML.parse(url)
            # css selector을 통해서 원하는 부분을 찾아간다.
            win = result.css('span.win').first
            lose = result.css('span.lose').first
            # 검색 결과를 페이지에서 보여주기 위한 변수 선언
            @win = win.text # 그냥win만 써주면 양 사이드에 태그가 그대로 붙어서 나올 가능성이 있으니까 .text로 깔끔하게 정리해준다.
            @lose = lose.text
            
        #검색 결과를 op.gg에서 보여준다.
        when 'opgg'
            url = URI.encode("http://www.op.gg/summoner/userName=#{params[:username]}")
            redirect url
        end
    end
    erb :op_gg
end
````

