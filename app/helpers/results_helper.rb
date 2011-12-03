module ResultsHelper

  def getstatistics(par)
#(questionary, a_id=0, filter={})

    questionary = par[:q]
    a_id = par[:a]
    filter = par[:f]
    if filter.nil? || filter.length == 0
      filtered = questionary.results.map { |res| res.information }
    else
      filtered = questionary.results.map do |res|
        res.information if filter.inject(false) do |r,i|
          r || (res.information.member? i)
        end
      end.compact
    end
    return filtered.inject(0) { |count,inf| (inf.member? a_id) || (a_id == 0) ? count+1: count }
  end

  def numOfColumns(questionary)

    questionary ||= Questionary.first
    questionary.questions.inject(0) do |ans, quest|
      [ans, quest.answers.length].max
    end
  end

  def filter

    if params[:count].nil? || (params[:count] == 0)
      nil
    else
      (0...params[:count].to_i).map do |i|
        params["a_#{i}".to_sym]
      end
    end
  end
end
