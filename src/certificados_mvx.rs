#![no_std]

#[allow(unused_imports)]
use multiversx_sc::imports::*;

/// Smart contract sencillo para gestión de certificados.
/// Solo almacena el hash del PDF y la dirección de la wallet del alumno.
#[multiversx_sc::contract]
pub trait CertificadosMvx {
    #[init]
    fn init(&self) {}

    #[upgrade]
    fn upgrade(&self) {}

    /// Expide un nuevo certificado: almacena el hash y la dirección del alumno.
    #[endpoint]
    fn expedir_certificado(
        &self,
        hash_certificado: ManagedBuffer,
        direccion_alumno: ManagedAddress,
    ) {
        require!(
            self.certificados(&hash_certificado).is_empty(),
            "Certificado ya existe"
        );
        self.certificados(&hash_certificado).set(&direccion_alumno);
        self.hashes_emitidos().push(&hash_certificado);
    }

    /// Consulta si un certificado (por hash) es válido (existe en la blockchain).
    #[view]
    fn es_certificado_valido(&self, hash_certificado: ManagedBuffer) -> bool {
        !self.certificados(&hash_certificado).is_empty()
    }

    /// Devuelve el listado de todos los hashes de certificados emitidos.
    #[view]
    fn listar_certificados(&self) -> ManagedVec<ManagedBuffer> {
        let mut resultado = ManagedVec::new();
        for hash in self.hashes_emitidos().iter() {
            resultado.push(hash);
        }
        resultado
    }
    #[view]
    fn hashes_por_wallet(&self, direccion_alumno: ManagedAddress) -> ManagedVec<ManagedBuffer> {
        let mut resultado = ManagedVec::new();
        for hash in self.hashes_emitidos().iter() {
            let direccion = self.certificados(&hash).get();
            if direccion == direccion_alumno {
                resultado.push(hash);
            }
        }
        resultado
    }
    
    
    /// Mapeo: hash del certificado -> dirección del alumno
    #[storage_mapper("certificados")]
    fn certificados(&self, hash_certificado: &ManagedBuffer) -> SingleValueMapper<ManagedAddress>;

    /// Lista de todos los hashes de certificados emitidos
    #[storage_mapper("hashesEmitidos")]
    fn hashes_emitidos(&self) -> VecMapper<ManagedBuffer>;
}
