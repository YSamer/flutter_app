String rePhone(String code, String phone) {
  if (code.endsWith('0') && phone.startsWith('0')) {
    phone = phone.substring(1);
  }
  return code + phone;
}
