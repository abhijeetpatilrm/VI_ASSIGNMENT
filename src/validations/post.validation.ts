import Joi from 'joi';

export const createPostSchema = Joi.object({
  content: Joi.string().required().min(1).max(5000).messages({
    'string.empty': 'Content is required',
    'string.min': 'Content cannot be empty',
    'string.max': 'Content cannot exceed 5000 characters',
  }),
  userId: Joi.number().integer().positive().required().messages({
    'number.base': 'User ID must be a number',
    'number.integer': 'User ID must be an integer',
    'number.positive': 'User ID must be a positive integer',
    'any.required': 'User ID is required',
  }),
});

export const updatePostSchema = Joi.object({
  content: Joi.string().min(1).max(5000).messages({
    'string.min': 'Content cannot be empty',
    'string.max': 'Content cannot exceed 5000 characters',
  }),
})
  .min(1)
  .messages({
    'object.min': 'At least one field must be provided for update',
  });
