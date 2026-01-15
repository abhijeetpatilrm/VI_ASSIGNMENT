import Joi from 'joi';

export const createFollowSchema = Joi.object({
  followerId: Joi.number().integer().positive().required().messages({
    'number.base': 'Follower ID must be a number',
    'number.integer': 'Follower ID must be an integer',
    'number.positive': 'Follower ID must be a positive integer',
    'any.required': 'Follower ID is required',
  }),
  followingId: Joi.number().integer().positive().required().messages({
    'number.base': 'Following ID must be a number',
    'number.integer': 'Following ID must be an integer',
    'number.positive': 'Following ID must be a positive integer',
    'any.required': 'Following ID is required',
  }),
}).custom((value, helpers) => {
  if (value.followerId === value.followingId) {
    return helpers.error('any.invalid', { message: 'You cannot follow yourself' });
  }
  return value;
}).messages({
  'any.invalid': 'You cannot follow yourself',
});

export const deleteFollowSchema = Joi.object({
  followerId: Joi.number().integer().positive().required().messages({
    'number.base': 'Follower ID must be a number',
    'number.integer': 'Follower ID must be an integer',
    'number.positive': 'Follower ID must be a positive integer',
    'any.required': 'Follower ID is required',
  }),
  followingId: Joi.number().integer().positive().required().messages({
    'number.base': 'Following ID must be a number',
    'number.integer': 'Following ID must be an integer',
    'number.positive': 'Following ID must be a positive integer',
    'any.required': 'Following ID is required',
  }),
});
