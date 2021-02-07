let SystemSetting = {};

SystemSetting.toggle_auth_method = button => {
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

SystemSetting.prop_fields = (fields, enable) => {
  fields.each((_, form_group) => {
    $(form_group).find('input').each((_, field) => {
      $(field).prop('disabled', !enable);
    });
    enable ? $(form_group).show() : $(form_group).hide();
  });
};

SystemSetting.change_password = link => {
  link.hide();
  link.next('input[type="password"]').show();
};

$(document).on('turbolinks:load', (() => {
  if (document.URL.match(/system_setting\/edit/)) {
    SystemSetting.prop_fields($('.auth-field').find('.form-group'), false);
    $('.auth-methods input[type="radio"]').on('change', event =>
      SystemSetting.toggle_auth_method($(event.currentTarget))
    );
    $('.auth-methods input[type="radio"]:checked').change();
    $('.change-client-secret').on('click', event =>
      SystemSetting.change_password($(event.currentTarget))
    );
  }
}));
