<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class CodigoRecuperacaoMail extends Mailable
{
    use Queueable, SerializesModels;

    public $codigo;
    public $nomeUsuario;

    /**
     * Create a new message instance.
     */
    public function __construct($codigo, $nomeUsuario = null)
    {
        $this->codigo = $codigo;
        $this->nomeUsuario = $nomeUsuario;
    }

    /**
     * Get the message envelope.
     */
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Código de Recuperação de Senha - ReconectaPet',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'emails.codigo-recuperacao',
            with: [
                'codigo' => $this->codigo,
                'nomeUsuario' => $this->nomeUsuario,
            ],
        );
    }

    /**
     * Get the attachments for the message.
     */
    public function attachments(): array
    {
        return [];
    }
}