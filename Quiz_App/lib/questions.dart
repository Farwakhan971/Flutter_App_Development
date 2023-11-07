import 'package:quiz_app_tutorial/question.dart';

const List<TrueFalseQuestion> trueFalseQuestions = [
  TrueFalseQuestion(
    question: '1. Flutter is a mobile app development framework.',
    correctAnswer: true,
  ),
  TrueFalseQuestion(
    question: '2. There are three main types of widgets in flutter.',
    correctAnswer: false,
  ),

  TrueFalseQuestion(
    question:
        '3. Dart programming language is used to build mobile applications in flutter.',
    correctAnswer: true,
  ),

  TrueFalseQuestion(
    question:
        '4. Expanded widget is used in flutter to give color to the text.',
    correctAnswer: false,
  ),

  TrueFalseQuestion(
    question:
        '5. Statlesswidget means that static data is shown on the screen.',
    correctAnswer: true,
  ),

  TrueFalseQuestion(
    question:
        '6. Statefulwidget is sued to show dynamic content on the screen of the app.',
    correctAnswer: true,
  ),
  // Add more true/false questions
];
const List<MultipleChoiceQuestion> multipleChoiceQuestions = [
  MultipleChoiceQuestion(
    question: '1. What is true about Machine Learning?',
    correctAnswerIndex: 3,
    options: [
      'a) Machine Learning (ML) is that field of computer science',
      'b)  ML is a type of artificial intelligence that extract patterns out of raw data by using an algorithm or method.',
      'c) The main focus of ML is to allow computer systems learn from experience without being explicitly programmed or human intervention.',
      'd) All of the above',
    ],
  ),
  MultipleChoiceQuestion(
    question: '2. ML is a field of AI consisting of learning algorithms that?',
    correctAnswerIndex: 3,
    options: [
      'a) Improve their performance',
      'b) At executing some task',
      'c) Over time with experience',
      'd) All of the above',
    ],
  ),
  MultipleChoiceQuestion(
    question:
        '3. A model of language consists of the categories which does not include?',
    correctAnswerIndex: 0,
    options: [
      'a) System Unit',
      'b) structural units',
      'c) empirical units',
      'd) data units',
    ],
  ),
  MultipleChoiceQuestion(
    question: '4. Different learning methods does not include?',
    correctAnswerIndex: 3,
    options: [
      'a) Introduction',
      'b) Analogy',
      'c) Deduction',
      'd) Memorization',
    ],
  ),
  MultipleChoiceQuestion(
    question:
        '5. The model will be trained with data in one single batch is known as ?',
    correctAnswerIndex: 1,
    options: [
      'a) Batch learning',
      'b) Offline learning',
      'c) Both A and B',
      'd) None of the above',
    ],
  ),
  MultipleChoiceQuestion(
    question: '6. Which of the following are ML methods?',
    correctAnswerIndex: 1,
    options: [
      'a) based on human supervision',
      'b) supervised Learning',
      'c) semi-reinforcement Learning',
      'd) All of the above',
    ],
  ),
  MultipleChoiceQuestion(
    question:
        '7. In Model based learning methods, an iterative process takes place on the ML models that are built based on various model parameters, called?',
    correctAnswerIndex: 3,
    options: [
      'a) mini-batches',
      'b) optimizedparameters',
      'c) hyperparameters',
      'd) superparameters',
    ],
  ),
  MultipleChoiceQuestion(
    question:
        '8. Which of the following is a widely used and effective machine learning algorithm based on the idea of bagging??',
    correctAnswerIndex: 1,
    options: [
      'a) Decision Tree',
      'b) Regression',
      'c) Classification',
      'd) Random Forest',
    ],
  ),
  MultipleChoiceQuestion(
    question:
        '9. To find the minimum or the maximum of a function, we set the gradient to zero because:?',
    correctAnswerIndex: 3,
    options: [
      'a) The value of the gradient at extrema of a function is always zero',
      'b) Depends on the type of problem',
      'c) Both A and B',
      'd) None of the above',
    ],
  ),
];
