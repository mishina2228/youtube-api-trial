let SystemSetting = {};

SystemSetting.toggle_auth_method = function (button) {
  SystemSetting.prop_fields($('.auth-field').find('.form-group'), false);

  const auth_method = button.val();
  switch (auth_method) {
    case 'api_key':
    case 'oauth2':
      const checked = button.is(':checked');
      SystemSetting.prop_fields($('.' + auth_method).find('.form-group'), checked);
      break;
    default:
      console.error('Unrecognized authentication method: ' + auth_method);
  }
};

SystemSetting.prop_fields = function (fields, enable) {
  fields.each(function (index, form_group) {
    $(form_group).find('input').each(function (i, field) {
      $(field).prop('disabled', !enable);
    });
    enable ? $(form_group).show() : $(form_group).hide();
  });
};

SystemSetting.change_password = function (link) {
  link.hide();
  link.next('input[type="password"]').show();
};
