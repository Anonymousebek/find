module SessionCounter
  private
    def reset_counter
      session[:counter] = 0
    end

    def increment_counter
      reset_counter if session[:counter].nil?
      @counter = session[:counter] + 1
      session[:counter] = @counter
    end
end
