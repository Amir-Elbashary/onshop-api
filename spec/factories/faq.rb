FactoryBot.define do
  factory :faq do
    question_en { Faker::Lorem.paragraph(1) }
    question_ar { Faker::Lorem.paragraph(1) }
    answer_en { Faker::Lorem.paragraph(1) }
    answer_ar { Faker::Lorem.paragraph(1) }
  end
end
