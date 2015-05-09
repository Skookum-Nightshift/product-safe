function flash(type, message) {
  $('body').append(
    '<div class="alert alert-' + type + ' alert-dismissible fade in" role="alert">' +
      '<button type="button" class="close" data-dismiss="alert" aria-label="Close">'+
      '<span aria-hidden="true">&times;</span></button>' +
      message + '</div>'
  );
}

function csrfRequest(method, path, data, success, error) {
  $.ajax({
    url: path,
    type: method,
    dataType: 'JSON',
    data: data,
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    },
    success: success,
    error: error
  });
}

var csrfPost = csrfRequest.bind(null, "POST");
var csrfGet = csrfRequest.bind(null, "GET");
var csrfPut = csrfRequest.bind(null, "PUT");
var csrfDelete = csrfRequest.bind(null, "DELETE");
var csrfPatch = csrfRequest.bind(null, "PATCH");
