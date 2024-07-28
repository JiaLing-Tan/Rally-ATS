import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

final roleProvider = ChangeNotifierProvider((ref) => RoleProviderModal());

class RoleProviderModal extends ChangeNotifier {
  Set _roles = [].toSet();
  List _rolesFilter = [];


  Set get role => _roles;
  List get rolesFilter => _rolesFilter;


  void populateRoles(candidates) {
    candidates.forEach((candidate) => role.add(candidate.role));
  }

  void addRoles(value) {
    _rolesFilter.add(value);

  }

  void removeRoles(value) {
    _rolesFilter.remove(value);

  }

}
