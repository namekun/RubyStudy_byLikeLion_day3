require "sinatra"
require "sinatra/reloader"
require "rest-client"
require "nokogiri"


get '/' do
    erb :app
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

get '/numbers' do
    erb :numbers
end

get '/form' do
   erb :form 
end

id = "multi"
pw = "campus"

post '/login' do
    if id.eql?(params[:id])
        # 비밀번호를 체크하는 로직
        if pw.eql?(params[:password])
            # erb :complete
            redirect '/complete'
        else
            @msg = "비밀번호가 틀립니다."
            redirect '/error?err_co=2' # 에러코드를 만들어주자.
        end
    else
        # ID가 존재하지 않습니다 라는 로직
        @msg = "아이디가 존재하지 않습니다."
        redirect '/error?err_co=1'
    end
end

# 계정이 존재하지않거나, 비밀번호가 틀린경우
get '/error' do
    erb :error
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

post '/search' do
    puts params[:engine]
    case params[:engine]
    when "naver"
        redirect "https://search.naver.com/search.naver?query=#{params[:query]}"
    when "google"
        redirect "https://www.google.com/search?q=#{params[:q]}"
    end
end

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
