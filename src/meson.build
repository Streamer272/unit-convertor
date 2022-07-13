unit_convertor_sources = [
  'main.vala',
  'window.vala',
  'application.vala',
]

unit_convertor_deps = [
  dependency('gtk4'),
  dependency('libadwaita-1')
]

gnome = import('gnome')

unit_convertor_sources += gnome.compile_resources('unit_convertor-resources',
  'unit_convertor.gresource.xml',
  c_name: 'unit_convertor'
)

executable('unit-convertor', unit_convertor_sources,
  vala_args: '--target-glib=2.50',  dependencies: unit_convertor_deps,
  install: true,
)
