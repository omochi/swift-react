#if os(WASI)
print("empty")
#else

import GenPagesModule

try GenPages().run()

#endif
