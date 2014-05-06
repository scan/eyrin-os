/**
 * Contains some declarations necessary for C++ compiling
 */

/**
 * Called by the C++ compiler when trying to access a non-defined virtual method.
 * 
 * Should not actually be called unless you ignore compiler warnings. No action necessary.
 *
 * \todo Perhaps add a screen exception.
 */
extern "C" void __cxa_pure_virtual() {
    // Nothing to do here
}
