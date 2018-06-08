# 20180608 Ruby With LikeLion - Day3

**새로운 폴더에 sinatra 프로젝트 넣기**

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

* post 요청을  ruby에서 받기위해서는 

  ````ruby
  post '/' do
  
  end
  ````

  * 기본적으로 POST 요청에 대한 로직은 직접 뷰를 렌더링하는 것이 아니라 다른 페이지로 redirect시킨다.
  * 새로고침등을 통한 접속불가등의 현상을 막기 위한 방침
  * 이후 게시판 글을 만드는 요청에 대한 로직을 구성시에도 동일한 방식으로 구성

**Form 이용해보기**

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

  

**검색창만들기** 

* /search 에는 검색어 입력창 두개
* 한개는 구글검색
* 한개는 네이버검색

*app.rb*

````ruby
get '/search' do
    erb :search
end

post '/search' do
    puts params[:engine]
    case params[:engine]
    when "naver"
        redirect "https://search.naver.com/search.naver?query=#{params[:query]}"
    when "google"
        redirect "https://www.google.com/search?q=#{params[:q]}"
    end
end

````

*search.rb*

````ruby
<p>----form action을 이용한 방법----</p>
<form action="https://search.naver.com/search.naver">
    <input type="text" name="query" placeholder="네이버 검색창">
    <input type="submit" value = "search">
</form>

<form action="https://www.google.com/search">
    <input type="text" name="q" placeholder="구글 검색창">
    <input type="submit" value = "search">
</form>

<p>----form method POST를 이용한 방법----</p>
<form method="POST">
    <input type="hidden" name="engine" value="naver">
    <input type="text" name="query" placeholder="네이버 검색">
    <input type="submit" value="검색">
</form>

<form method="POST">
    <input type="hidden" name="engine" value="google">
    <input type="text" name="q" placeholder="구글 검색">
    <input type="submit" value="검색">
</form>
````



