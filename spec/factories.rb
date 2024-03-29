Factory.sequence(:question_id) { |n| n }
Factory.sequence(:questionary_id) { |n| n }
Factory.sequence(:answer_id) { |n| n }

Factory.define :questionary do |questionary|
  questionary.after_build do |qry|
    id = Factory.next :questionary_id
    qry.name = "Questionary_#{id}"
    qry.description = "This is a discription of the questionary ##{id}"
  end
end

Factory.define :question do |question|
  question.after_build do |qon|
    id = Factory.next :question_id
    qon.num = id
    qon.content = "Question_#{id}"
    qon.extra_answer = true
    qon.multians = 1
  end
  question.association :questionary
end

Factory.define :answer do |answer|
  answer.after_build do |ans|
    id = Factory.next :answer_id
    ans.num = id
    ans.content = "Answer_#{id}"
    ans.verified = true
  end
  answer.association :question
end
