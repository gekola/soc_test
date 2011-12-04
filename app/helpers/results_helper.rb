module ResultsHelper

  def getstatistics(par)
#(questionary, a_id=0)

    questionary = par[:q]
    @a_id = par[:a]
    #filter = par[:f]
    filtered = questionary.results.map { |res| res.information }
    filtered.map! do |inf|
      if filter.inject(false) { |r,i| (r || (inf.member? i)) } || filter == []
        inf
      else
        nil
      end
    end
    filtered.compact!
    return (filtered.inject(0) { |count,inf| ((inf.member? @a_id) || (@a_id == 0)) ? count+1 : count })
  end

  def numOfColumns(questionary)

    questionary ||= Questionary.first
    questionary.questions.inject(0) do |ans, quest|
      [ans, quest.answers.length].max
    end
  end

  def chparams(ans)

    param = params.clone
    if filter.member? ans
      param[:count] = filter.length - 1
      filter.inject(0) do |i,ans_id|
        if ans_id != ans
          param["a_#{i}".to_sym] = ans_id
          i+1
        else
          i
        end
        param["a_#{filter.length-1}"] = nil
      end
    else
      param = param.merge({ :count => filter.length+1, "a_#{filter.length}".to_sym => ans })
    end
    param
  end

  def filter

    if params[:count].nil? || (params[:count] == 0)
      []
    else
      (0...params[:count].to_i).map do |i|
        params["a_#{i}".to_sym].to_i
      end
    end
  end
end
