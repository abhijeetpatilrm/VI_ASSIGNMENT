import Joi from 'joi';

export const createLikeSchema = Joi.object({
  userId: Joi.number().integer().positive().required().messages({
    'number.base': 'User ID must be a number',
    'number.integer': 'User ID must be an integer',
    'number.positive': 'User ID must be a positive integer',
    'any.required': 'User ID is required',
  }),
  postId: Joi.number().integer().positive().required().messages({
    'number.base': 'Post ID must be a number',
    'number.integer': 'Post ID must be an integer',
    'number.positive': 'Post ID must be a positive integer',
    'any.required': 'Post ID is required',
  }),
});

export const deleteLikeSchema = Joi.object({
  userId: Joi.number().integer().positive().required().messages({
    'number.base': 'User ID must be a number',
    'number.integer': 'User ID must be an integer',
    'number.positive': 'User ID must be a positive integer',
    'any.required': 'User ID is required',
  }),
  postId: Joi.number().integer().positive().required().messages({
    'number.base': 'Post ID must be a number',
    'number.integer': 'Post ID must be an integer',
    'number.positive': 'Post ID must be a positive integer',
    'any.required': 'Post ID is required',
  }),
});
