Factory.define :questionary do |questionary|
  questionary.name          "Cinema"
  questionary.description   "Cinema influence"
end

Factory.sequence(:question_id) { |n| n }

Factory.define :question do |q|
  q.after_build do |question|
    id = Factory.next :question_id
    question.num = id
    question.content = "Question_#{id}"
  end
  q.association :questionary
end
